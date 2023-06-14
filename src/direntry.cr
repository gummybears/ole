#
# direntry.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
require "./helper.cr"
require "./constants.cr"
require "./string.cr"

module Ole

  class DirectoryEntry
    #
    # name            : string, containing entry name in unicode UTF-16 (max 31 chars) + null char = 64 bytes
    # size of name    : uint16, number of bytes used in name buffer, including null = (len+1)*2
    # type            : uint8,  between 0 and 5
    # color           : uint8,  0 = black, 1 = red
    # left_sid        : uint32, index of left child node in the red-black tree, NOSTREAM if none
    # right_sid       : uint32, index of right child node in the red-black tree, NOSTREAM if none
    # child_sid       : uint32, index of child root node if it is a storage, else NOSTREAM
    # clsid           : string, 16 bytes, unique identifier (only used if it is a storage)
    # user_flags      : uint32, user flags
    # ctime           : uint64, creation timestamp or zero
    # mtime           : uint64, modification timestamp or zero
    # start_sector    : uint32, SID of first sector if stream or ministream, SID of 1st sector
    #                           of stream containing ministreams if root entry, 0 otherwise
    # size            : uint64, total stream size in bytes
    #
    property name         : String = ""           #  64     0,  64, 64
    property size_name    : UInt16 = 0            #   2    64,  66,  2
    property type         : UInt8  = 0            #   1    66,  67,  1
    property color        : UInt8  = 0            #   1    67,  68,  1
    property left_sid     : UInt32 = 0            #   4    68,  72,  4
    property right_sid    : UInt32 = 0            #   4    72,  76,  4
    property child_sid    : UInt32 = 0            #   4    76,  80,  4
    property clsid        : Bytes  = Bytes.new(0) #  16    80,  96, 16
    property user_flags   : UInt32 = 0            #   4    96, 100,  4
    property ctime        : Time = Time.local     #   8   100, 108,  8
    property mtime        : Time = Time.local     #   8   108, 116,  8
    property start_sector : UInt32 = 0            #   4   116, 120,  4
    property size         : UInt64 = 0            #   8,  120, 128,  8

    property errors       : Array(String) = [] of String
    property error        : String = ""
    property data         : Bytes = Bytes[0]

    # dummy initializer
    def initialize
    end

    def initialize(data : Bytes,byte_order : Ole::ByteOrder)

      @data       = data
      #
      # minus 2 as to NOT include the 2 bytes
      # marking the end of the string
      #
      @size_name  = ::Ole.endian_u16(_size_name(),byte_order)

      #
      # size_name could be 0
      #
      @name = ""
      if @size_name > 2
        @name = ::Ole.le_string(_name(),@size_name-2).to_s()
      end

      @type         = ::Ole.endian_u8(_type(),byte_order)
      @color        = ::Ole.endian_u8(_color(),byte_order)
      @left_sid     = ::Ole.endian_u32(_left_sid(),byte_order)
      @right_sid    = ::Ole.endian_u32(_right_sid(),byte_order)
      @child_sid    = ::Ole.endian_u32(_child_sid(),byte_order)

      #
      # size of clsid is 16, but need to remove last 2 bytes from _clsid as these are null bytes
      # to indicate end of UTF16 string
      #
      @clsid        = _clsid()
      @user_flags   = ::Ole.endian_u32(_user_flags(),byte_order)
      @ctime        = ::Ole.le_datetime(_ctime())
      @mtime        = ::Ole.le_datetime(_mtime())
      @start_sector = ::Ole.endian_u32(_start_sector(),byte_order)
      @size         = ::Ole.endian_u64(_size(),byte_order)
    end

    def is_stream?() : Bool
      x = false
      case @type
        when 2
          x = true
      end

      return x
    end

    def is_ministream?() : Bool
      x = is_stream?()

      #
      # is this a stream and the size < 4 K
      #
      if x && @size <= FOUR_K
        return true
      end

      return x
    end

    #
    # size of directory entry is 128
    #
    def self.size() : Int32
      64 + 2 + 1 + 1 + 4 + 4 + 4 + 16 + 4 + 8 + 8 + 4 + 4 +4
    end

    #
    # Note: epos is not used
    # however I decided to leave it as a parameter
    # more esthetic. Also could be used as
    # internal check
    #
    private def get_data(spos,epos,len)
      endpos = spos + len - 1
      @data[spos..endpos]
    end

    def name_utf16
      _name()
    end

    private def _name()
      get_data(0,64,64)
    end

    private def _size_name()
      get_data(64,66,2)
    end

    private def _type()
      get_data(66,67,1)
    end

    private def _color()
      get_data(67,68,1)
    end

    private def _left_sid()
      get_data(68,72,4)
    end

    private def _right_sid
      get_data(72,76,4)
    end

    private def _child_sid
      get_data(76,80,4)
    end

    private def _clsid()
      get_data(80,96,16)
    end

    private def _user_flags()
      get_data(96,100,4)
    end

    private def _ctime()
      get_data(100,108,8)
    end

    private def _mtime()
      get_data(108,116,8)
    end

    private def _start_sector()
      get_data(116,120,4)
    end

    private def _size()
      get_data(120,128,8)
    end

    def id_to_s(index : UInt32) : String

      s= ""
      case index
        when Ole::FREESECT, Ole::ENDOFCHAIN
          s = S_NONE #"none"
        else
          s = index.to_s
      end

      return s
    end

    def dump(index : Int32, join : String = " ") : String

      # not used start_time = Time.utc(1601,1,1,0,0,0)

      name = ""
      if @name.size > 0
        name = String.to_utf8(@name.chars)
      else
        name = S_EMPTY # "Empty"
      end

      t = ""
      case @type
        when 0
          t = S_UNKNOWN # "Unknown"
        when 1
          t = S_STORAGE # "Storage"
        when 2
          t = S_STREAM # "Stream"
        when 3
          t = S_LOCKBYTES # "LockBytes"
        when 4
          t = S_PROPERTY # "Property"
        when 5
          t = S_ROOT # "Root"
        else
          t = S_INVALID # "Invalid"
      end


      left  = @left_sid
      right = @right_sid
      child = @child_sid

      fat_type = ""
      if t == S_STREAM # "Stream"
        fat_type = S_FAT # "FAT"
        if @size <= FOUR_K # 4 * 1024
          fat_type = S_MINIFAT #"Mini FAT"
        end
      end

      if t == S_ROOT
        fat_type = S_FAT #"FAT"
      end

      s_left = id_to_s(left)
      s_right = id_to_s(right)
      s_child = id_to_s(child)
      s_first = id_to_s(@start_sector)

      s = sprintf("%6d %-30s %-12s %8s %8s %12s %12s %8d %8s",index,name,t,s_left,s_right,s_child,s_first,@size,fat_type)
      return s
    end

    def bytes_to_hex(b : Bytes) : String
      x = ""
      b.each do |e|
        x = x + sprintf("%0.2x",e).upcase + " "
      end
      x
    end
  end
end

#
# direntry.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
#require "./helper.cr"
#require "./constants.cr"

module Ole

  class DirectoryEntry

    # name            : string, containing entry name in unicode UTF-16 (max 31 chars) + null char = 64 bytes
    # number of bytes : uint16, number of bytes used in name buffer, including null = (len+1)*2
    # type            : uint8,  between 0 and 5
    # color           : uint8,  0 = black, 1 = red
    # left            : uint32, index of left child node in the red-black tree, NOSTREAM if none
    # right           : uint32, index of right child node in the red-black tree, NOSTREAM if none
    # child           : uint32, index of child root node if it is a storage, else NOSTREAM
    # clsid           : string, 16 bytes, unique identifier (only used if it is a storage)
    # user_flags      : uint32, user flags
    # ctime           : uint64, creation timestamp or zero
    # mtime           : uint64, modification timestamp or zero
    # sid             : uint32, SID of first sector if stream or ministream, SID of 1st sector
    #                           of stream containing ministreams if root entry, 0 otherwise
    # size_min        : uint32, total stream size in bytes if stream (low 32 bits), 0 otherwise
    # size_max        : uint32, total stream size in bytes if stream (high 32 bits), 0 otherwise

    property name       : String = ""
    property nr_bytes   : UInt16 = 0
    property type       : UInt8  = 0
    property color      : UInt8  = 0
    property left_sid   : UInt32 = 0
    property right_sid  : UInt32 = 0
    property child_sid  : UInt32 = 0
    property clsid      : String = ""
    property user_flags : UInt32 = 0
    property ctime      : UInt64 = 0
    property mtime      : UInt64 = 0
    property sid        : UInt32 = 0
    property size_min   : UInt32 = 0
    property size_max   : UInt32 = 0
    property size       : Int32 = 0

    property errors : Array(String) = [] of String
    property error  : String = ""
    property data   : Bytes

    def initialize(data : Bytes)
      @data = data
    end

    # def type() : Ole::Storage
    #   return Ole::Storage::Empty
    # end
    #
    # def size() : Int32
    #   return 0
    # end
  end
end

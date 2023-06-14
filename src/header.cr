#
# header.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
#
require "./helper.cr"

module Ole
  #
  # A class which wraps the ole header
  # see https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-cfb/05060311-bfce-4b12-874d-71fd4ce63aea?redirectedfrom=MSDN
  #

  #
  # Note:
  # For version 4 compound files, the header size (512 bytes) is less than the sector size (4,096 bytes),
  # so the remaining part of the header (3,584 bytes) MUST be filled with all zeroes
  #

  class Header
                                                                 #   size     # start offset (decimal)
    # property magic                : Bytes = Bytes.new(8)       #   8 bytes     0
    # property clsid                : Bytes = Bytes.new(16)      #  16 bytes     8
    # property minor_version        : Bytes = Bytes.new(2)       #   2 bytes    24
    # property major_version        : Bytes = Bytes.new(2)       #   2 bytes    26
    # property byte_order           : Bytes = Bytes.new(2)       #   2 bytes    28
    # property sector_shift         : Bytes = Bytes.new(2)       #   2 bytes    30
    # property mini_sector_shift    : Bytes = Bytes.new(2)       #   2 bytes    32
    # property reserved             : Bytes = Bytes.new(6)       #   6 bytes    34
    # property nr_dir_sectors       : Bytes = Bytes.new(4)       #   4 bytes    40
    # property nr_fat_sectors       : Bytes = Bytes.new(4)       #   4 bytes    44
    # property first_dir_sector     : Bytes = Bytes.new(4)       #   4 bytes    48
    # property trans_sig_number     : Bytes = Bytes.new(4)       #   4 bytes    52
    # property mini_stream_cutoff   : Bytes = Bytes.new(4)       #   4 bytes    56
    # property first_minifat_sector : Bytes = Bytes.new(4)       #   4 bytes    60
    # property nr_mini_fat_sectors  : Bytes = Bytes.new(4)       #   4 bytes    64
    # property first_difat_loc      : Bytes = Bytes.new(4)       #   4 bytes    68
    # property nr_dfat_sectors      : Bytes = Bytes.new(4)       #   4 bytes    72
    # property difat                : Bytes = Bytes.new(436)     # 436 bytes    from 76, first 109 = (436/4) FAT sector locations
    #
    property errors               : Array(String) = [] of String
    property status               : Int32 = 0
    property error                : String = ""
    property data                 : Bytes  = Bytes.new(0)

    property magic                : String = ""
    property clsid                : String = ""
    property minor_version        : UInt16 = 0
    property major_version        : UInt16 = 0
    property byte_order           : Ole::ByteOrder = Ole::ByteOrder::None
    property sector_shift         : UInt16 = 0
    property mini_sector_shift    : UInt16 = 0
    property reserved             : String = ""
    property nr_dir_sectors       : UInt32 = 0
    property nr_fat_sectors       : UInt32 = 0
    property first_dir_sector     : UInt32 = 0
    property trans_sig_number     : UInt32 = 0
    property mini_stream_cutoff   : UInt32 = 0
    property first_minifat_sector : UInt32 = 0
    property nr_mini_fat_sectors  : UInt32 = 0
    property first_difat_pos      : UInt32 = 0
    property nr_dfat_sectors      : UInt32 = 0
    property difat                : Array(UInt32)  = [] of UInt32

    def initialize
    end

    def initialize(data : Bytes)
      @data       = data
      @byte_order = determine_byteorder()

      #
      # fill in difat array
      #
      spos     = 76
      nr_bytes = 4
      (0..109-1).each do |i|
        epos  = spos + nr_bytes - 1
        @difat << ::Ole.endian_u32(data[spos..epos],@byte_order)
        spos = epos + 1
      end

      @magic                = ::Ole.to_hex(_magic(),@byte_order,"")
      @clsid                = ::Ole.to_hex(_clsid(),@byte_order,"")
      @minor_version        = ::Ole.endian_u16(_minor_version(),@byte_order)
      @major_version        = ::Ole.endian_u16(_major_version(),@byte_order)
      @sector_shift         = ::Ole.endian_u16(_sector_shift(),@byte_order)
      @mini_sector_shift    = ::Ole.endian_u16(_mini_sector_shift(),@byte_order)
      @reserved             = ::Ole.to_hex(_reserved(),@byte_order,"")
      @nr_dir_sectors       = ::Ole.endian_u32(_nr_dir_sectors(),@byte_order)
      @nr_fat_sectors       = ::Ole.endian_u32(_nr_fat_sectors(),@byte_order)
      @first_dir_sector     = ::Ole.endian_u32(_first_dir_sector_pos(),@byte_order)
      @trans_sig_number     = ::Ole.endian_u32(_trans_sig_number(),@byte_order)
      @mini_stream_cutoff   = ::Ole.endian_u32(_mini_stream_cutoff(),@byte_order)
      @first_minifat_sector = ::Ole.endian_u32(_first_mini_fat_pos(),@byte_order)
      @nr_mini_fat_sectors  = ::Ole.endian_u32(_nr_mini_fat_sectors(),@byte_order)
      @first_difat_pos      = ::Ole.endian_u32(_first_difat_pos(),@byte_order)
      @nr_dfat_sectors      = ::Ole.endian_u32(_nr_dfat_sectors(),@byte_order)
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

    def determine_byteorder() : Ole::ByteOrder
      lv_byte_order = Ole::ByteOrder::None

      x = get_data(28,30,2)
      if x[0] == 0xff && x[1] == 0xfe
        lv_byte_order = Ole::ByteOrder::BigEndian
      end

      if x[0] == 0xfe && x[1] == 0xff
        lv_byte_order = Ole::ByteOrder::LittleEndian
      end

      lv_byte_order
    end

    def dump()
      puts "Misc".colorize(:green).mode(:bold)
      puts
      puts "Magic                #{::Ole.to_hex(_magic)}"
      puts "Clsid                #{@clsid}"
      puts "Minor version        0x#{@minor_version.to_s(16)}"
      puts "Major version        0x#{@major_version.to_s(16)}"

      case @byte_order
        when Ole::ByteOrder::LittleEndian
          puts "Byte order           Little Endian"

        when Ole::ByteOrder::BigEndian
          puts "Byte order           Big Endian"

        else
          puts "Byte order           None"
      end
      puts "Reserved             #{@reserved}"
      puts "Trans sig number     #{@trans_sig_number}"

      puts
      puts "FAT".colorize(:green).mode(:bold)
      puts
      puts "# sectors            #{@nr_fat_sectors}"
      puts "Sector shift         #{@sector_shift}"
      puts "Sector size          #{sector_size()}"

      puts
      puts "Mini FAT".colorize(:green).mode(:bold)
      puts
      puts "# sectors            #{@nr_mini_fat_sectors}"
      puts "First block          #{@first_minifat_sector}"
      puts "Sector shift         #{@mini_sector_shift}"
      puts "Sector size          #{minifat_sector_size()}"
      puts "Stream cutoff        #{@mini_stream_cutoff}"

      puts
      puts "Directory".colorize(:green).mode(:bold)
      puts
      puts "# sectors            #{@nr_dir_sectors}"
      puts "First block          #{@first_dir_sector}"

      puts
      puts "DIFAT".colorize(:green).mode(:bold)
      puts

      puts "# sectors            #{@nr_dfat_sectors}"
      puts "First block          #{@first_difat_pos}"
      puts

    end

    private def _magic()
      get_data(0,8,8)
    end

    private def _clsid()
      get_data(8,24,16)
    end

    private def _minor_version
      get_data(24,26,2)
    end

    private def _major_version
      get_data(26,28,2)
    end

    private def _byte_order
      get_data(28,30,2)
    end

    private def _sector_shift
      get_data(30,32,2)
    end

    private def _mini_sector_shift
      get_data(32,34,2)
    end

    private def _reserved
      get_data(34,40,6)
    end

    private def _nr_dir_sectors
      get_data(40,44,4)
    end

    private def _nr_fat_sectors
      get_data(44,48,4)
    end

    private def _first_dir_sector_pos
      get_data(48,52,4)
    end

    private def _trans_sig_number
      get_data(52,56,4)
    end

    private def _mini_stream_cutoff
      get_data(56,60,4)
    end

    private def _first_mini_fat_pos
      get_data(60,64,4)
    end

    private def _nr_mini_fat_sectors
      get_data(64,68,4)
    end

    private def _first_difat_pos
      get_data(68,72,4)
    end

    private def _nr_dfat_sectors
      get_data(72,76,4)
    end

    def size() : Int32
      x = 8 + 16 + 5 * 2 + 6 + 9 * 4 + 109 * 4
      x
    end

    def version : Int32
      r = 0
      x = _major_version()
      if x[0] == 0x03 && x[1] == 0x0
        r = 3
      elsif x[0] == 0x04 && x[1] == 0x0
        r = 4
      end

      r
    end

    #
    # returns the sector size
    # version 3 : 512
    # version 4 : 4096
    #
    def sector_size : Int32
      2 ** @sector_shift
    end

    def minifat_sector_size() : Int32
      2 ** @mini_sector_shift
    end

    #
    # Page 20
    #
    # Next Sector in Chain (variable): This field specifies the next sector number in a chain of sectors.
    # If Header Major Version is 3, there MUST be 128 fields specified   to fill a 512-byte sector.
    # If Header Major Version is 4, there MUST be 1,024 fields specified to fill a 4,096-byte sector.
    #
    def nr_fat_fields : Int32
      r = 0
      case version()
        when 3
          r = EIGHT_K # 128
        when 4
          r = ONE_K # 1024
        else
          #@errors << "invalid Ole structure"

          set_error("invalid Ole structure")
          r = 0
      end

      r
    end

    def set_error(s : String)
      @errors << "ole error : #{s}"
      @status = -1
    end

    def validate_magic
      r = (::Ole.to_hex(_magic) == "0xd0cf11e0a1b11ae1")
      if r == false
        set_error("invalid Ole header signature")
      end
      r
    end

    def validate_clsid
      r = (::Ole.to_hex(_clsid) == "0x0000000000000000")
      if r == false
        set_error("invalid Ole class id")
      end
      r
    end

    def validate_byteorder
      r = (::Ole.to_hex(_byte_order) == "0xfeff")
      if r == false
        set_error("invalid Ole byte order")
      end
      r
    end

    #
    # Sector Shift (2 bytes):
    # This field MUST be set to 0x0009, or 0x000c, depending on the Major Version field.
    # This field specifies the sector size of the compound file as a power of 2.
    #
    # If Major Version is 3, the Sector Shift MUST be 0x0009, specifying a sector size of 512 bytes.
    # If Major Version is 4, the Sector Shift MUST be 0x000C, specifying a sector size of 4096 bytes.
    #
    def validate_sectorshift
      x = _sector_shift
      s = ::Ole.to_hex(x)

      case version
        when 3
          return s == "0x90"

        when 4
          return s == "0xc0"

        else
          return false
      end

      false
    end

    def validate_minor_sector_shift
       ::Ole.to_hex(_mini_sector_shift) == "0x60"
    end

    def validate_reserved
      x = _reserved
      x.each do |i|
        if x[i] != 0
          return false
        end

      end

      return true
    end

    def validate_nr_dir_sectors
      s = ::Ole.to_hex(_nr_dfat_sectors)
      case version
        when 3
          return s == "0x0000"
        else
          return true

      end

      return true
    end

    def validate : Bool
      x = validate_magic              &&
          validate_clsid              &&
          validate_byteorder          &&
          validate_sectorshift        &&
          validate_minor_sector_shift &&
          validate_nr_dir_sectors     &&
          validate_reserved

      if x == false
        set_error("not a valid Ole structure storage file")
      end

      return x
    end

    def to_bytes() : Bytes
      #data = Bytes.new(512)
      io = IO::Memory.new
      # old code io.write_bytes(@magic, IO::ByteFormat::LittleEndian)
      # old code io.write_bytes(@clsid                , IO::ByteFormat::LittleEndian)
      io.write_bytes(@minor_version        , IO::ByteFormat::LittleEndian)
      io.write_bytes(@major_version        , IO::ByteFormat::LittleEndian)
      # old code io.write_bytes(@byte_order           , IO::ByteFormat::LittleEndian)
      io.write_bytes(@sector_shift         , IO::ByteFormat::LittleEndian)
      io.write_bytes(@mini_sector_shift    , IO::ByteFormat::LittleEndian)
      # old code io.write_bytes(@reserved             , IO::ByteFormat::LittleEndian)
      io.write_bytes(@nr_dir_sectors       , IO::ByteFormat::LittleEndian)
      io.write_bytes(@nr_fat_sectors       , IO::ByteFormat::LittleEndian)
      io.write_bytes(@first_dir_sector     , IO::ByteFormat::LittleEndian)
      io.write_bytes(@trans_sig_number     , IO::ByteFormat::LittleEndian)
      io.write_bytes(@mini_stream_cutoff   , IO::ByteFormat::LittleEndian)
      io.write_bytes(@first_minifat_sector , IO::ByteFormat::LittleEndian)
      io.write_bytes(@nr_mini_fat_sectors  , IO::ByteFormat::LittleEndian)
      io.write_bytes(@first_difat_pos      , IO::ByteFormat::LittleEndian)
      io.write_bytes(@nr_dfat_sectors      , IO::ByteFormat::LittleEndian)
      @difat.each do |x|
        io.write_bytes(x, IO::ByteFormat::LittleEndian)
      end

      io.to_slice # => Bytes[0x34, 0x12]

    end

  end
end

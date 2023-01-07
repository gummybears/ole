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
    # property first_mini_fat_loc   : Bytes = Bytes.new(4)       #   4 bytes    60
    # property nr_mini_fat_sectors  : Bytes = Bytes.new(4)       #   4 bytes    64
    # property first_difat_loc      : Bytes = Bytes.new(4)       #   4 bytes    68
    # property nr_dfat_sectors      : Bytes = Bytes.new(4)       #   4 bytes    72
    # property difat                : Bytes = Bytes.new(436)     # 436 bytes    from 76, first 109 = (436/4) FAT sector locations
    #
    property errors               : Array(String) = [] of String
    property error                : String = ""
    property data                 : Bytes

    property magic                : String = ""
    property clsid                : String = ""
    property minor_version        : UInt16 = 0
    property major_version        : UInt16 = 0
    property byte_order           : Ole::ByteOrder # UInt16 = 0
    property sector_shift         : UInt16 = 0
    property mini_sector_shift    : UInt16 = 0
    property reserved             : String = ""
    property nr_dir_sectors       : UInt32 = 0
    property nr_fat_sectors       : UInt32 = 0
    property first_dir_sector     : UInt32 = 0
    property trans_sig_number     : UInt32 = 0
    property mini_stream_cutoff   : UInt32 = 0
    property first_mini_fat_pos   : UInt32 = 0
    property nr_mini_fat_sectors  : UInt32 = 0
    property first_difat_pos      : UInt32 = 0
    property nr_dfat_sectors      : UInt32 = 0
    property difat                : Array(UInt32)  = [] of UInt32

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


      # old code lv_byte_order =  Ole::ByteOrder::LittleEndian

      # read the byte order first
      #@byte_order   = ::Ole.le_u16(_byte_order())
      # old code lv_byte_order = @byte_order
      # old code @magic                = ::Ole.to_raw(_magic(),lv_byte_order)
      # old code @clsid                = ::Ole.to_raw(_clsid(),lv_byte_order)
      # old code @minor_version        = ::Ole.le_u16(_minor_version())
      # old code @major_version        = ::Ole.le_u16(_major_version())
      # old code @byte_order           = ::Ole.le_u16(_byte_order())
      # old code @sector_shift         = ::Ole.le_u16(_sector_shift())
      # old code @mini_sector_shift    = ::Ole.le_u16(_mini_sector_shift())
      # old code @reserved             = ::Ole.to_raw(_reserved(),lv_byte_order)
      # old code @nr_dir_sectors       = ::Ole.le_u32(_nr_dir_sectors())
      # old code @nr_fat_sectors       = ::Ole.le_u32(_nr_fat_sectors())
      # old code @first_dir_sector     = ::Ole.le_u32(_first_dir_sector_loc())
      # old code @trans_sig_number     = ::Ole.le_u32(_trans_sig_number())
      # old code @mini_stream_cutoff   = ::Ole.le_u32(_mini_stream_cutoff())
      # old code @first_mini_fat_loc   = ::Ole.le_u32(_first_mini_fat_loc())
      # old code @nr_mini_fat_sectors  = ::Ole.le_u32(_nr_mini_fat_sectors())
      # old code @first_difat_loc      = ::Ole.le_u32(_first_difat_loc())
      # old code @nr_dfat_sectors      = ::Ole.le_u32(_nr_dfat_sectors())

      @magic                = ::Ole.to_raw(_magic(),@byte_order)
      @clsid                = ::Ole.to_raw(_clsid(),@byte_order)
      @minor_version        = ::Ole.endian_u16(_minor_version(),@byte_order)
      @major_version        = ::Ole.endian_u16(_major_version(),@byte_order)
      # old code @byte_order           = ::Ole.endian_u16(_byte_order(),@byte_order)
      @sector_shift         = ::Ole.endian_u16(_sector_shift(),@byte_order)
      @mini_sector_shift    = ::Ole.endian_u16(_mini_sector_shift(),@byte_order)
      @reserved             = ::Ole.to_raw(_reserved(),@byte_order)
      @nr_dir_sectors       = ::Ole.endian_u32(_nr_dir_sectors(),@byte_order)
      @nr_fat_sectors       = ::Ole.endian_u32(_nr_fat_sectors(),@byte_order)
      @first_dir_sector     = ::Ole.endian_u32(_first_dir_sector_pos(),@byte_order)
      @trans_sig_number     = ::Ole.endian_u32(_trans_sig_number(),@byte_order)
      @mini_stream_cutoff   = ::Ole.endian_u32(_mini_stream_cutoff(),@byte_order)
      @first_mini_fat_pos   = ::Ole.endian_u32(_first_mini_fat_pos(),@byte_order)
      @nr_mini_fat_sectors  = ::Ole.endian_u32(_nr_mini_fat_sectors(),@byte_order)
      @first_difat_pos      = ::Ole.endian_u32(_first_difat_pos(),@byte_order)
      @nr_dfat_sectors      = ::Ole.endian_u32(_nr_dfat_sectors(),@byte_order)
    end

    private def get_data(spos,epos,len)
      #
      # Note: epos is not used
      # however I decided to leave it as a parameter
      # more esthetic. Also could be used as
      # internal check
      #
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
      puts "magic                #{@magic}"
      puts "clsid                #{@clsid}"
      puts "minor_version        #{@minor_version}"
      puts "major_version        #{@major_version}"
      # old code puts "byte_order           #{@byte_order}"

      case @byte_order
        when Ole::ByteOrder::LittleEndian # 0xfffe
          puts "byte_order           LittleEndian"

        when Ole::ByteOrder::BigEndian # 0xfeff
          puts "byte_order           BigEndian"

        else
          puts "byte_order           None"
      end

      puts "sector_shift         #{@sector_shift}"
      puts "sector_size          #{sector_size()}"
      puts "mini_sector_shift    #{@mini_sector_shift}"
      puts "mini_sector_size     #{2**@mini_sector_shift}"
      puts "reserved             #{@reserved}"
      puts "first_dir_sector     #{@first_dir_sector}"
      puts "trans_sig_number     #{@trans_sig_number}"
      puts "mini_stream_cutoff   #{@mini_stream_cutoff}"
      puts "first_mini_fat_pos   #{@first_mini_fat_pos}"
      puts "first_difat_pos      #{@first_difat_pos}"
      puts "nr_dir_sectors       #{@nr_dir_sectors}"
      puts "nr_fat_sectors       #{@nr_fat_sectors}"
      puts "nr_mini_fat_sectors  #{@nr_mini_fat_sectors}"
      puts "nr_dfat_sectors      #{@nr_dfat_sectors}"
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

    # not used def dfat()
    # not used   get_data(76,76+436,436)
    # not used end

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

    def sector_size : Int32
      # old code r = 0
      # old code case version()
      # old code   when 3
      # old code     r = 2 ** @sector_shift
      # old code     # old code r = 512
      # old code   when 4
      # old code     # old code r = 4096
      # old code     r = 2 ** @sector_shift
      # old code   else
      # old code     @errors << "invalid Ole sector size"
      # old code     r = 0
      # old code end

      2 ** @sector_shift
    end


    def mini_sector_size() : Int32
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
          r = 128
        when 4
          r = 1024
        else
          @errors << "invalid Ole structure"
          r = 0
      end

      r
    end

    def validate_magic
      r = (::Ole.to_hex(_magic) == "0xd0cf11e0a1b11ae1")
      if r == false
        @errors << "invalid Ole header signature"
      end
      r
    end

    def validate_clsid
      r = (::Ole.to_hex(_clsid) == "0x0000000000000000")
      if r == false
        @errors << "invalid Ole class id"
      end
      r
    end

    def validate_byteorder
      r = (::Ole.to_hex(_byte_order) == "0xfeff")
      if r == false
        @errors << "invalid Ole byte order"
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
        @error = "not a valid Ole structure storage file"
      end

      return x
    end

  end
end

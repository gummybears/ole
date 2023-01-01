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
    # property first_dir_sector_loc : Bytes = Bytes.new(4)       #   4 bytes    48
    # property trans_sig_number     : Bytes = Bytes.new(4)       #   4 bytes    52
    # property mini_stream_cutoff   : Bytes = Bytes.new(4)       #   4 bytes    56
    # property first_mini_fat_loc   : Bytes = Bytes.new(4)       #   4 bytes    60
    # property nr_mini_fat_sectors  : Bytes = Bytes.new(4)       #   4 bytes    64
    # property first_difat_loc      : Bytes = Bytes.new(4)       #   4 bytes    68
    # property nr_dfat_sectors      : Bytes = Bytes.new(4)       #   4 bytes    72
    # property difat                : Bytes = Bytes.new(436)     # 436 bytes    from 76, first 109 = (436/4) FAT sector locations
    #
    property errors : Array(String) = [] of String
    property error  : String = ""
    property data   : Bytes

    property magic                : String         = ""
    property clsid                : String         = ""
    property minor_version        : Int32          = 0
    property major_version        : Int32          = 0
    property byte_order           : Int32          = 0 # Ole::ByteOrder = Ole::ByteOrder::LittleEndian
    property sector_shift         : Int32          = 0
    property mini_sector_shift    : Int32          = 0
    property reserved             : String         = ""
    property nr_dir_sectors       : Int32          = 0
    property nr_fat_sectors       : Int32          = 0
    property first_dir_sector_loc : Int32          = 0
    property trans_sig_number     : Int32          = 0
    property mini_stream_cutoff   : Int32          = 0
    property first_mini_fat_loc   : Int32          = 0
    property nr_mini_fat_sectors  : Int32          = 0
    property first_difat_loc      : Int32          = 0
    property nr_dfat_sectors      : Int32          = 0
    property difat                : Array(Int32)   = [] of Int32

    def initialize(data : Bytes)
      @data    = data

      #
      # fill in difat array
      #
      spos     = 76
      nr_bytes = 4

      (0..108).each do |i|
        epos   = spos + nr_bytes - 1
        @difat << ::Ole.little_endian(data[spos..epos]).to_i32

        spos = epos + 1
      end

      lv_byte_order         =  Ole::ByteOrder::LittleEndian
      @magic                = ::Ole.to_raw(_magic(),lv_byte_order)
      @clsid                = ::Ole.to_raw(_clsid(),lv_byte_order)
      @minor_version        = ::Ole.little_endian(_minor_version()).to_i32
      @major_version        = ::Ole.little_endian(_major_version()).to_i32
      @byte_order           = ::Ole.little_endian(_byte_order()).to_i32
      @sector_shift         = ::Ole.little_endian(_sector_shift()).to_i32
      @mini_sector_shift    = ::Ole.little_endian(_mini_sector_shift()).to_i32
      @reserved             = ::Ole.to_raw(_reserved(),lv_byte_order)
      @nr_dir_sectors       = ::Ole.little_endian(_nr_dir_sectors()).to_i32
      @nr_fat_sectors       = ::Ole.little_endian(_nr_fat_sectors()).to_i32
      @first_dir_sector_loc = ::Ole.little_endian(_first_dir_sector_loc()).to_i32
      @trans_sig_number     = ::Ole.little_endian(_trans_sig_number()).to_i32
      @mini_stream_cutoff   = ::Ole.little_endian(_mini_stream_cutoff()).to_i32
      @first_mini_fat_loc   = ::Ole.little_endian(_first_mini_fat_loc()).to_i32
      @nr_mini_fat_sectors  = ::Ole.little_endian(_nr_mini_fat_sectors()).to_i32
      @first_difat_loc      = ::Ole.little_endian(_first_difat_loc()).to_i32
      @nr_dfat_sectors      = ::Ole.little_endian(_nr_dfat_sectors()).to_i32

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

    # def dump()
    #
    #   byte_order = Ole::ByteOrder::LittleEndian
    #
    #   puts "magic                #{::Ole.to_hex(magic(),byte_order)}"
    #   puts "clsid                #{::Ole.to_hex(clsid())}"
    #   puts "minor_version        #{::Ole.to_hex(minor_version(),byte_order,true)}"
    #   puts "major_version        #{::Ole.to_hex(major_version(),byte_order,true)}"
    #   puts "byte_order           #{::Ole.to_hex(byte_order(),byte_order,true)}"
    #   puts "sector_shift         #{::Ole.to_hex(sector_shift(),byte_order,true)}"
    #   puts "mini_sector_shift    #{::Ole.to_hex(mini_sector_shift(),byte_order,true)}"
    #   puts "reserved             #{::Ole.to_hex(reserved(),byte_order,true)}"
    #   puts "first_dir_sector_loc #{::Ole.to_hex(first_dir_sector_loc(),byte_order,true)}"
    #   puts "trans_sig_number     #{::Ole.to_hex(trans_sig_number(),byte_order,true)}"
    #   puts "mini_stream_cutoff   #{::Ole.to_hex(mini_stream_cutoff(),byte_order,true)}"
    #   puts "first_mini_fat_loc   #{::Ole.to_hex(first_mini_fat_loc(),byte_order,true)}"
    #   puts "first_difat_loc      #{::Ole.to_hex(first_difat_loc(),byte_order,true)}"
    #
    #   puts "nr_dir_sectors       #{::Ole.little_endian(nr_dir_sectors())}"
    #   puts "nr_fat_sectors       #{::Ole.little_endian(nr_fat_sectors())}"
    #   puts "nr_mini_fat_sectors  #{::Ole.little_endian(nr_mini_fat_sectors())}"
    #   puts "nr_dfat_sectors      #{::Ole.little_endian(nr_dfat_sectors())}"
    # end

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

    private def _first_dir_sector_loc
      get_data(48,52,4)
    end

    private def _trans_sig_number
      get_data(52,56,4)
    end

    private def _mini_stream_cutoff
      get_data(56,60,4)
    end

    private def _first_mini_fat_loc
      get_data(60,64,4)
    end

    private def _nr_mini_fat_sectors
      get_data(64,68,4)
    end

    private def _first_difat_loc
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
      r = 0
      case version()
        when 3
          r = 512
        when 4
          r = 4096
        else
          @errors << "invalid Ole sector size"
          r = 0
      end

      r
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

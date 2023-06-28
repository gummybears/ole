#
# header2.cr
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

  class Header2
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
    property size                 : UInt32 = 512.to_u32

    def initialize(blob : Ole::Blob)

      @byte_order    = determine_byteorder(blob)
      @magic         = sprintf("%0x",blob.read_64bits(@byte_order))
      @clsid         = sprintf("%0s",blob.read_bytes(16))
      @minor_version = blob.read_16bits(@byte_order)
      @major_version = blob.read_16bits(@byte_order)

      #
      # skip 2 bytes as byte_order is already read
      #
      blob.io.pos = blob.io.pos + 2

      @sector_shift = blob.read_16bits(@byte_order)
    end

    def determine_byteorder(blob : Ole::Blob) : Ole::ByteOrder
      lv_byte_order = Ole::ByteOrder::None

      # save io pos
      old_pos = blob.io.pos
      blob.io.pos = 28

      x = blob.read_bytes(2)
      if x[0] == 0xff && x[1] == 0xfe
        lv_byte_order = Ole::ByteOrder::BigEndian
      end

      if x[0] == 0xfe && x[1] == 0xff
        lv_byte_order = Ole::ByteOrder::LittleEndian
      end

      # restore io pos
      blob.io.pos = old_pos

      lv_byte_order
    end

  end
end

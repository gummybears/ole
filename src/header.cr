require "./helper.cr"

module Ole
  #
  # A class which wraps the ole header
  # see https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-cfb/05060311-bfce-4b12-874d-71fd4ce63aea?redirectedfrom=MSDN
  #
  class Header
                                                                      #   size    # offset (decimal)
    property magic                : Bytes = Bytes.new(8)  # Int32 = 0 #  8 bytes         0
    property clsid                : Bytes = Bytes.new(16) # Int32 = 0 # 16 bytes         8
    property minor_version        : Bytes = Bytes.new(2)  # Int32 = 0 #  2 bytes        24
    property major_version        : Bytes = Bytes.new(2)  # Int32 = 0 #  2 bytes        26
    property byte_order           : Bytes = Bytes.new(2)  # Int32 = 0 #  2 bytes        28
    property sector_shift         : Bytes = Bytes.new(2)  # Int32 = 0 #  2 bytes        30
    property mini_sector_shift    : Bytes = Bytes.new(2)  # Int32 = 0 #  2 bytes        32
    property reserved             : Bytes = Bytes.new(6)  # Int32 = 0 #  6 bytes        38
    property nr_dir_sectors       : Bytes = Bytes.new(4)  # Int32 = 0 #  4 bytes        42
    property nr_fat_sectors       : Bytes = Bytes.new(4)  # Int32 = 0 #  4 bytes        46
    property first_dir_sector_loc : Bytes = Bytes.new(4)  # Int32 = 0 #  4 bytes        50
    property trans_sig_number     : Bytes = Bytes.new(4)  # Int32 = 0 #  4 bytes        54
    property mini_stream_cutoff   : Bytes = Bytes.new(4)  # Int32 = 0 #  4 bytes        58
    property first_mini_fat_loc   : Bytes = Bytes.new(4)  # Int32 = 0 #  4 bytes        62
    property nr_mini_fat_sectors  : Bytes = Bytes.new(4)  # Int32 = 0 #  4 bytes        66
    property first_difat_loc      : Bytes = Bytes.new(4)  # Int32 = 0 #  4 bytes        70
    property difat                : Array(Int32) = [] of Int32 # first 109 FAT sector locations

    property data : Bytes

    #
    # Note:
    # For version 4 compound files, the header size (512 bytes) is less than the sector size (4,096 bytes),
    # so the remaining part of the header (3,584 bytes) MUST be filled with all zeroes
    #
    def initialize(data : Bytes)
      @data = data
    end

    # property dirent_start  : Int32 = 0
    # property num_bat       : Int32 = 0
    # property num_sbat      : Int32 = 0
    # property num_mbat      : Int32 = 0

    #  8 bytes starting at pos 0
    def magic()
      startpos = 0
      endpos   = startpos + 8 - 1
      @data[startpos..endpos]
    end

    # 16 bytes at pos 8
    def clsid()
      startpos = 8
      endpos   = startpos + 16 - 1
      @data[startpos..endpos]
    end

    def minor_version
    end

    def major_version
    end

    def byte_order
    end

    def sector_shift
    end

      # @header.minor_version        = @data[24..24+2-1]  #  2 bytes        24
      # @header.major_version        = @data[26..26+2-1]  #  2 bytes        26
      # @header.byte_order           = @data[28..28+2-1]  #  2 bytes        28
      # @header.sector_shift         = @data[30..30+2-1]  #  2 bytes        30
      # @header.mini_sector_shift    = @data[32..32+2-1]  #  2 bytes        32
      # @header.reserved             = @data[34..34+6-1]  #  6 bytes        38
      # @header.nr_dir_sectors       = @data[30         #  4 bytes        42
      # @header.nr_fat_sectors       = @data[30         #  4 bytes        46
      # @header.first_dir_sector_loc = @data[30         #  4 bytes        50
      # @header.trans_sig_number     = @data[30         #  4 bytes        54
      # @header.mini_stream_cutoff   = @data[30         #  4 bytes        58
      # @header.first_mini_fat_loc   = @data[30         #  4 bytes        62
      # @header.nr_mini_fat_sectors  = @data[30         #  4 bytes        66
      # @header.first_difat_loc      = @data[30         #  4 bytes        70



  end
end

#    class Header < Struct.new(
#        :magic, :clsid, :minor_ver, :major_ver, :byte_order, :b_shift, :s_shift,
#        :reserved, :csectdir, :num_bat, :dirent_start, :transacting_signature, :threshold,
#        :sbat_start, :num_sbat, :mbat_start, :num_mbat
#      )
#      PACK = 'a8 a16 v2 a2 v2 a6 V3 a4 V5'
#      SIZE = 0x4c
#      # i have seen it pointed out that the first 4 bytes of hex,
#      # 0xd0cf11e0, is supposed to spell out docfile. hmmm :)
#      MAGIC = "\xd0\xcf\x11\xe0\xa1\xb1\x1a\xe1"  # expected value of Header#magic
#      # what you get if creating new header from scratch.
#      # AllocationTable::EOC isn't available yet. meh.
#      EOC = 0xfffffffe
#      DEFAULT = [
#        MAGIC, 0.chr * 16, 59, 3, "\xfe\xff", 9, 6,
#        0.chr * 6, 0, 1, EOC, 0.chr * 4,
#        4096, EOC, 0, EOC, 0
#      ]
#
#      def initialize values=DEFAULT
#        values = values.unpack(PACK) if String === values
#        super(*values)
#        validate!
#      end
#
#      def to_s
#        to_a.pack PACK
#      end
#
#      def validate!
#        raise FormatError, "OLE2 signature is invalid" unless magic == MAGIC
#        if num_bat == 0 or # is that valid for a completely empty file?
#           # not sure about this one. basically to do max possible bat given size of mbat
#           num_bat > 109 && num_bat > 109 + num_mbat * (1 << b_shift - 2) or
#           # shouldn't need to use the mbat as there is enough space in the header block
#           num_bat < 109 && num_mbat != 0 or
#           # given the size of the header is 76, if b_shift <= 6, blocks address the header.
#           s_shift > b_shift or b_shift <= 6 or b_shift >= 31 or
#           # we only handle little endian
#           byte_order != "\xfe\xff"
#          raise FormatError, "not valid OLE2 structured storage file"
#        end
#        # relaxed this, due to test-msg/qwerty_[1-3]*.msg they all had
#        # 3 for this value.
#        # transacting_signature != "\x00" * 4 or
#        if threshold != 4096 or
#           num_mbat == 0 && ![AllocationTable::EOC, AllocationTable::AVAIL].include?(mbat_start) or
#           reserved != "\x00" * 6
#          Log.warn "may not be a valid OLE2 structured storage file"
#        end
#        true
#      end
#    end
#
#

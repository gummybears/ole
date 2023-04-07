#
# fat.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

module Ole

  module Fat

    #
    # Read the FAT table
    #
    def read_fat()

      @header.difat.each do |sector|
        if sector == Ole::ENDOFCHAIN
          break
        end

        if sector == Ole::FREESECT
          break
        end

        read_fat_sector(sector.to_u32)
      end
    end

    #
    # first convert the raw data into decoded sector indices
    # the raw data contains Little Endian encoded sector indices
    # 4 bytes long
    #
    def read_fat_sector(sector : UInt32)

      bytes = read_sector(sector)
      if bytes.size != @header.sector_size
        #raise "broken FAT, sector size is #{bytes.size} but should be #{@header.sector_size}"
        @errors << "broken FAT, sector size is #{bytes.size} but should be #{@header.sector_size}"
        @status = -1
        return
      end

      (0...bytes.size - 1).step(4) do |x|
        arr    = bytes[x..x+3]
        sector = ::Ole.endian_u32(arr,@header.byte_order)
        @fat << sector
      end
    end
  end
end

#
# minifat.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

module Ole

  module MiniFat

    #
    # Read the Ministream
    #
    def read_ministream()
    end


    #
    # Read the Mini FAT table
    #
    def read_minifat(sector : UInt32)

      #
      # Start at sector @header.first_mini_fat_pos
      # take into account the header offset
      #
      # so for sector 2 we need to go to
      #
      # offset = (sector + 1) * sector_size()
      #        = 3 * 512 = 1536
      #

      # old code sector = @header.first_mini_fat_pos
      # old code while true
      # old code
      # old code   if sector == Ole::ENDOFCHAIN
      # old code     break
      # old code   end
      # old code
      # old code   if sector == Ole::FREESECT
      # old code     break
      # old code   end
      # old code
      # old code   read_minifat_sector(sector.to_u32)
      # old code end


      #while true
      #
      #  if sector == Ole::ENDOFCHAIN
      #    break
      #  end
      #
      #  if sector == Ole::FREESECT
      #    break
      #  end
      #
      #  read_minifat_chain(sector)
      #end

      read_minifat_chain(sector)
    end

    # old code def read_minifat_sector(sector : UInt32)
    # old code
    # old code   #bytes = read_minifat_sector(sector)
    # old code   bytes = read_sector()
    # old code   #if bytes.size != @header.mini_sector_size()
    # old code   if bytes.size != @header.sector_size()
    # old code     @errors << "broken mini FAT, sector size is #{bytes.size} but should be #{@header.mini_sector_size}"
    # old code     @status = -1
    # old code     return
    # old code   end
    # old code
    # old code   (0...bytes.size - 1).step(4) do |x|
    # old code     arr    = bytes[x..x+3]
    # old code     sector = ::Ole.endian_u32(arr,@header.byte_order)
    # old code     @minifat << sector
    # old code   end
    # old code end

    def read_minifat(bytes : Bytes) : Array(UInt32)

      ids = [] of UInt32

      #if bytes.size != @header.mini_sector_size()
      if bytes.size != @header.sector_size()
        @errors << "broken mini FAT, sector size is #{bytes.size} but should be #{@header.sector_size}"
        @status = -1
        return ids
      end

      (0...bytes.size - 1).step(4) do |x|
        arr    = bytes[x..x+3]
        sector = ::Ole.endian_u32(arr,@header.byte_order)
        ids << sector
      end

      return ids
    end

  end
end

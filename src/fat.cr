#
# fat.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

# moved to readers.cr module Ole
# moved to readers.cr
# moved to readers.cr   module Fat
# moved to readers.cr
# moved to readers.cr     #
# moved to readers.cr     # Read the FAT table
# moved to readers.cr     #
# moved to readers.cr     def read_fat()
# moved to readers.cr
# moved to readers.cr       @header.difat.each do |sector|
# moved to readers.cr         if sector == Ole::ENDOFCHAIN
# moved to readers.cr           break
# moved to readers.cr         end
# moved to readers.cr
# moved to readers.cr         if sector == Ole::FREESECT
# moved to readers.cr           break
# moved to readers.cr         end
# moved to readers.cr
# moved to readers.cr         read_fat_sector(sector.to_u32)
# moved to readers.cr       end
# moved to readers.cr     end
# moved to readers.cr
# moved to readers.cr     #
# moved to readers.cr     # first convert the raw data into decoded sector indices
# moved to readers.cr     # the raw data contains Little Endian encoded sector indices
# moved to readers.cr     # 4 bytes long
# moved to readers.cr     #
# moved to readers.cr     def read_fat_sector(sector : UInt32)
# moved to readers.cr
# moved to readers.cr       bytes = read_sector(sector)
# moved to readers.cr       if bytes.size != @header.sector_size
# moved to readers.cr         #raise "broken FAT, sector size is #{bytes.size} but should be #{@header.sector_size}"
# moved to readers.cr         #@errors << "broken FAT, sector size is #{bytes.size} but should be #{@header.sector_size}"
# moved to readers.cr         #@status = -1
# moved to readers.cr         set_error("broken FAT, sector size is #{bytes.size} but should be #{@header.sector_size}")
# moved to readers.cr         return
# moved to readers.cr       end
# moved to readers.cr
# moved to readers.cr       (0...bytes.size - 1).step(4) do |x|
# moved to readers.cr         arr    = bytes[x..x+3]
# moved to readers.cr         sector = ::Ole.endian_u32(arr,@header.byte_order)
# moved to readers.cr         @fat << sector
# moved to readers.cr       end
# moved to readers.cr     end
# moved to readers.cr   end
# moved to readers.cr end
# moved to readers.cr

#
# minifat.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

# moved to readers.cr module Ole
# moved to readers.cr
# moved to readers.cr   module MiniFat
# moved to readers.cr
# moved to readers.cr     #
# moved to readers.cr     # Read the Ministream
# moved to readers.cr     #
# moved to readers.cr     def read_ministream(bytes : Bytes) : Bytes
# moved to readers.cr
# moved to readers.cr       x = bytes.dup
# moved to readers.cr       # unsure about this code ?? if x.size < @directories[0].size
# moved to readers.cr       # unsure about this code ??   set_error("specified size is larger than actual stream length #{bytes.size}")
# moved to readers.cr       # unsure about this code ??   return x
# moved to readers.cr       # unsure about this code ?? end
# moved to readers.cr       #x = bytes[0..@directories[0].size]
# moved to readers.cr
# moved to readers.cr       #s = ::Ole.to_raw(x,@byte_order)
# moved to readers.cr       #s = ::Ole.le_string(x,x.size).to_s()
# moved to readers.cr       return x
# moved to readers.cr     end
# moved to readers.cr
# moved to readers.cr     #
# moved to readers.cr     # Read the Mini FAT table
# moved to readers.cr     #
# moved to readers.cr     def read_minifat(sector : UInt32)
# moved to readers.cr       #
# moved to readers.cr       # Start at sector @header.first_mini_fat_pos
# moved to readers.cr       # take into account the header offset
# moved to readers.cr       #
# moved to readers.cr       # so for sector 2 we need to go to
# moved to readers.cr       #
# moved to readers.cr       # offset = (sector + 1) * sector_size()
# moved to readers.cr       #        = 3 * 512 = 1536
# moved to readers.cr       #
# moved to readers.cr       read_minifat_chain(sector)
# moved to readers.cr     end
# moved to readers.cr
# moved to readers.cr     def read_minifat(bytes : Bytes) : Array(UInt32)
# moved to readers.cr
# moved to readers.cr       ids = [] of UInt32
# moved to readers.cr
# moved to readers.cr       #if bytes.size != @header.mini_sector_size()
# moved to readers.cr       if bytes.size != @header.sector_size()
# moved to readers.cr         #@errors << "broken mini FAT, sector size is #{bytes.size} but should be #{@header.sector_size}"
# moved to readers.cr         #@status = -1
# moved to readers.cr         set_error("broken mini FAT, sector size is #{bytes.size} but should be #{@header.sector_size}")
# moved to readers.cr
# moved to readers.cr         return ids
# moved to readers.cr       end
# moved to readers.cr
# moved to readers.cr       (0...bytes.size - 1).step(4) do |x|
# moved to readers.cr         arr    = bytes[x..x+3]
# moved to readers.cr         sector = ::Ole.endian_u32(arr,@header.byte_order)
# moved to readers.cr         ids << sector
# moved to readers.cr       end
# moved to readers.cr
# moved to readers.cr       return ids
# moved to readers.cr     end
# moved to readers.cr
# moved to readers.cr   end
# moved to readers.cr end
# moved to readers.cr

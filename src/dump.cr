#
# dump.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

module Ole

  module Dump

    # old code #
    # old code # Dump FAT (for debugging only)
    # old code #
    # old code def dump_fat
    # old code
    # old code   puts
    # old code   puts "FAT (max nr sectors #{max_nr_sectors})"
    # old code   puts
    # old code
    # old code   x = @header.nr_fat_sectors
    # old code   if x == 0
    # old code     return
    # old code   end
    # old code
    # old code   startpos      = @header.sector_size
    # old code   nr_fat_fields = @header.nr_fat_fields
    # old code
    # old code   #
    # old code   # read 4 bytes at a time
    # old code   #
    # old code   spos = startpos
    # old code   epos = startpos + nr_fat_fields
    # old code   (spos..epos).step(4).each do |i|
    # old code     spos = i
    # old code     epos = spos + 4 - 1
    # old code
    # old code     d = @data[spos..epos]
    # old code     v = ::Ole.to_hex(d,@byte_order,true)
    # old code
    # old code     x = sprintf("%0.4x",i).upcase
    # old code
    # old code     case v
    # old code       when "0xfffffffd"
    # old code         #puts "0x#{i.to_s(16)} : fat sector"
    # old code         puts "0x#{x} : fat sector"
    # old code
    # old code       when "0xfffffffe"
    # old code         #puts "0x#{i.to_s(16)} : end of chain"
    # old code         puts "0x#{x} : end of chain"
    # old code
    # old code       when "0xffffffff"
    # old code         #puts "0x#{i.to_s(16)} : free sector"
    # old code         puts "0x#{x} : free sector"
    # old code
    # old code       else
    # old code         #puts "0x#{i.to_s(16)} : #{v.upcase}"
    # old code         puts "0x#{x} : #{v.upcase}"
    # old code
    # old code     end
    # old code
    # old code   end
    # old code end

    #
    # Dump FAT (for debugging only)
    #
    def dump_fat
      puts
      puts "FAT (max nr sectors #{max_nr_sectors})"
      puts

      i = 0
      @fat.each do |e|

        s = sprintf("%0.8x",e).upcase
        x = sprintf("%0.4x",i).upcase

        case e
          when Ole::FATSECT
            puts "0x#{x} : fat sector"

          when Ole::ENDOFCHAIN
            puts "0x#{x} : end of chain"

          when Ole::FREESECT
            puts "0x#{x} : free sector"

          else
            puts "0x#{x} : 0x#{s}"

        end

        i = i + 1
      end
    end

    #
    # Dump DiFAT (for debugging only)
    #
    def dump_difat

      puts
      puts "DIFAT (#{@header.nr_dfat_sectors} sectors)"
      puts

      # old code #
      # old code # process header difat array
      # old code #
      # old code difat_pos      = 76
      # old code difat_nr_bytes = 4
      # old code (0..@header.difat.size - 1).each do |i|
      # old code
      # old code   d = @header.difat[i]
      # old code
      # old code   a = sprintf("0x%0.3x",i * difat_nr_bytes + difat_pos)
      # old code   v = sprintf("0x%0.8x",d)
      # old code   puts "#{a} : #{v}"
      # old code end

      i = 0
      @header.difat.each do |e|

        s = sprintf("%0.8x",e).upcase
        x = sprintf("%0.4x",i).upcase

        case e
          when Ole::FATSECT
            puts "0x#{x} : fat sector"

          when Ole::ENDOFCHAIN
            puts "0x#{x} : end of chain"

          when Ole::FREESECT
            puts "0x#{x} : free sector"

          else
            puts "0x#{x} : 0x#{s}"

        end

        i = i + 1
      end

    end

    #
    # Dump sector (for debugging only)
    #
    def dump_sector(sector : Int32, first_index : Int32 = 0)
    end

    #
    # dump some header information
    # debug purposes
    #
    def dump
      puts
      puts "dump of file #{@filename}"
      puts
      @header.dump()
      dump_difat()
      dump_fat()
    end

    #
    # Dump directories (for debugging only)
    #
    def dump_directories
      @directories.each do |e|
        puts e.dump
        puts
      end
    end

    #
    # Dump minifat
    #
    def dump_minifat
      puts
      puts "Mini FAT"
      puts

      i = 0
      @minifat.each do |e|

        s = sprintf("%0.8x",e).upcase
        x = sprintf("%0.4x",i).upcase

        case e
          when Ole::FATSECT
            puts "0x#{x} : minifat sector"

          when Ole::ENDOFCHAIN
            puts "0x#{x} : end of chain"

          when Ole::FREESECT
            puts "0x#{x} : free sector"

          else
            puts "0x#{x} : 0x#{s}"

        end

        i = i + 1
      end
    end

    #
    # Dump ministreams
    #
    def dump_ministreams
      i = 0
      @directories.each do |e|
        if e.name != "empty"
          puts "#{i} : #{e.name}"
          i =  i + 1
        end
      end
    end
  end
end

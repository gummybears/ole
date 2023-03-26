#
# dump.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

module Ole

  module Dump

    #
    # Dump FAT (for debugging only)
    #
    def dump_fat

      puts
      puts "FAT (max nr sectors #{max_nr_sectors})"
      puts

      x = @header.nr_fat_sectors
      if x == 0
        return
      end

      startpos      = @header.sector_size
      nr_fat_fields = @header.nr_fat_fields

      #
      # read 4 bytes at a time
      #
      spos = startpos
      epos = startpos + nr_fat_fields
      (spos..epos).step(4).each do |i|
        spos = i
        epos = spos + 4 - 1

        d = @data[spos..epos]
        v = ::Ole.to_hex(d,@byte_order,true)
        case v
          when "0xfffffffd"
            puts "0x#{i.to_s(16)} : fat sector"

          when "0xfffffffe"
            puts "0x#{i.to_s(16)} : end of chain"

          when "0xffffffff"
            puts "0x#{i.to_s(16)} : free sector"

          else
            puts "0x#{i.to_s(16)} : #{v}"

        end

      end
    end

    #
    # Dump DiFAT (for debugging only)
    #
    def dump_difat

      puts
      puts "DIFAT (#{@header.nr_dfat_sectors} sectors)"
      puts

      #
      # process header difat array
      #

      difat_pos = 76
      difat_nr_bytes = 4
      (0..@header.difat.size - 1).each do |i|

        d = @header.difat[i]

        a = sprintf("0x%0.3x",i * difat_nr_bytes + difat_pos)
        v = sprintf("0x%0.8x",d)
        puts "#{a} : #{v}"
        #puts "0x#{i.to_s(16)} : #{v}"
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
    # Dump directory (for debugging only)
    #
    def dump_directory
      # @root.dump()
    end

  end
end

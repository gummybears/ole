#
# dump.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

require "./constants.cr"

module Ole

  module Dump

    def print_dump_file()
      puts
      puts "Dump of file '#{@filename}'".colorize(:green)
      puts
    end

    def print_hex_dump()
      puts
      puts "Hex dump".colorize(:green)
      puts
    end

    def print_header()
      #puts
      puts "Header".colorize(:green)
      puts
    end

    def print_ministreams()
      puts
      puts "Mini streams".colorize(:green)
      puts
    end

    def print_directories()
      puts
      puts "Directories".colorize(:green)
      puts
    end

    def print_fat_header()
      puts
      puts "FAT (max nr sectors #{max_nr_sectors})".colorize(:green)
      puts
    end

    def print_minifat_header()
      puts
      puts "Mini FAT".colorize(:green)
      puts
    end

    def print_difat_header()
      puts
      puts "DIFAT (#{@header.nr_dfat_sectors} sectors)".colorize(:green)
      puts
    end

    def print_offset(i : Int32) : String
      s = "0x"
      s = s + sprintf("%0.4x ",i).upcase
      s = s + sprintf("(%0.4d) : ",i)
      return s
    end

    #
    # Dump FAT (for debugging only)
    #
    def dump_fat()

      print_fat_header()

      i = 0
      @fat.each do |e|

        s = print_offset(i)
        x = sprintf("%0.8x",e).upcase

        case e
          when Ole::FATSECT
            puts "#{s}#{Ole::S_FATSECTOR}"

          when Ole::ENDOFCHAIN
            puts "#{s}#{Ole::S_ENDOFCHAIN}"

          when Ole::FREESECT
            puts "#{s}#{Ole::S_FREESECTOR}"

          else
            puts "#{s}0x#{x}"

        end

        i = i + 1
      end
    end

    #
    # Dump DiFAT (for debugging only)
    #
    def dump_difat()

      if @header.nr_dfat_sectors == 0
        puts "No DIFAT sectors found"
        return
      end

      print_difat_header()

      i = 0
      @header.difat.each do |e|

        s = print_offset(i)
        x = sprintf("%0.8x",e).upcase

        case e
          when Ole::FATSECT
            puts "#{s}#{Ole::S_FATSECTOR}"

          when Ole::ENDOFCHAIN
            puts "#{s}#{Ole::S_ENDOFCHAIN}"

          when Ole::FREESECT
            puts "#{s}#{Ole::S_FREESECTOR}"

          else
            puts "#{s}0x#{x}"
        end

        i = i + 1
      end

    end

    #
    # dump some header information
    # debug purposes
    #
    def dump_file()

      print_dump_file()

      dump_header()
      dump_directories()
      dump_difat()
      dump_fat()
      dump_minifat()

      dump_ministreams()
      dump_hex()
    end

    #
    # Dump directories (for debugging only)
    #
    def dump_directories()

      print_directories()

      @directories.each do |e|
        puts e.dump
        puts
      end
    end

    #
    # Dump minifat
    #
    def dump_minifat()

      print_minifat_header()

      i = 0
      @minifat.each do |e|

        s = print_offset(i)
        x = sprintf("%0.8x",e).upcase

        case e
          when Ole::FATSECT
            puts "#{s}#{Ole::S_FATSECTOR}"

          when Ole::ENDOFCHAIN
            puts "#{s}#{Ole::S_ENDOFCHAIN}"

          when Ole::FREESECT
            puts "#{s}#{Ole::S_FREESECTOR}"

          else
            puts "#{s}0x#{x}"
        end

        i = i + 1
      end
    end

    #
    # Dump ministreams
    #
    def dump_ministreams

      print_ministreams()

      i = 0
      @directories.each do |e|
        if e.name != ""
          puts "#{i} : #{e.name}"
          i =  i + 1
        end
      end
    end

    #
    # Dump stream by name
    #
    def dump_stream(name : String)
      found, data = get_stream(name)
      puts data
    end

    #
    # Dump sector (for debugging only)
    #
    def dump_sector(sector : UInt32)
      read_sector(sector)
    end

    #
    # Dump header
    #
    def dump_header()

      print_header()
      @header.dump()
    end

    def dump_hex()

      print_hex_dump()

      len           = data.size - 1
      sector_number = 0

      (0..len).step(16) do |i|

        s = print_offset(i)
        print s

        (0..15).each do |k|

          m = i + k
          if m < len
            value = sprintf("%0.2x",@data[i+k]).upcase
            print value
            print " "
          else
            print "--"
            print " "
          end

        end # k loop

        print "| "

        #
        # print the chr value
        #
        (0..15).each do |k|

          m = i + k
          if m < len

            chr_value = @data[i+k].chr
            ord_value = @data[i+k]

            case ord_value
              when 0..31
                print "."
              when 127..255
                print "."
              else
                print chr_value
            end

            print " "

          else

            print " "
            print " "

          end
        end # k loop

        print "| "

        #
        # Print sector number
        #
        sector_size = sector_size()
        if (i % sector_size) == 0

          if i == 0
            print S_HEADER.colorize.fore(:green).mode(:bold)
          end

          #
          # sectors start after the header
          #
          if i > 0
            print "<< sector #{sector_number - 1} >> ".colorize.fore(:yellow).mode(:bold)
          end

          if sector_number > 0
            sector_type = get_sector_type(sector_number.to_u32 - 1)
            if sector_type != ""
              print sector_type.colorize.fore(:green).mode(:bold)
            end
          end

          # old code, see get_sector_type, dir_sector = get_sector_offset(@header.first_dir_sector)
          # old code, see get_sector_type, if i == dir_sector
          # old code, see get_sector_type,   print S_DIRECTORY.colorize.fore(:green).mode(:bold)
          # old code, see get_sector_type, end

          sector_number = sector_number + 1
        end
        puts
      end
    end
  end
end

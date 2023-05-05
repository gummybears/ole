#
# dump.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

module Ole

  module Dump

    def print_fat_header()
      puts
      puts "FAT (max nr sectors #{max_nr_sectors})"
      puts
    end

    def print_minifat_header()
      puts
      puts "Mini FAT"
      puts
    end


    def print_difat_header()
      puts
      puts "DIFAT (#{@header.nr_dfat_sectors} sectors)"
      puts
    end

    #
    # Dump FAT (for debugging only)
    #
    def dump_fat

      print_fat_header()

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

      if @header.nr_dfat_sectors == 0
        puts "No DIFAT sectors found"
        return
      end

      print_difat_header()

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
    # dump some header information
    # debug purposes
    #
    def dump()
      puts
      puts "dump of file '#{@filename}'"
      puts
      @header.dump()
      dump_difat()
      dump_fat()
    end

    #
    # Dump directories (for debugging only)
    #
    def dump_directories()
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

      # #
      # # convert name to UTF-16 Big Endian
      # #
      # x   = name.encode("UTF-16BE")
      # len = x.size
      #
      # @directories.each do |e|
      #   if e.name == ""
      #     next
      #   end
      #
      #   #
      #   # need to trim the directory name to (len - 1)
      #   # to do comparison
      #   #
      #   name_utf16 = e.name.to_utf16[0..len-1]
      #
      #   if name_utf16 == x
      #     data = read_sector(e.start_sector)
      #     #if data.size > 0
      #     return data
      #     #end
      #   end
      # end
    end

    #
    # Get stream by name
    #
    def get_stream(name : String) : {Bool, Bytes}

      #
      # convert name to UTF-16 Big Endian
      #
      x   = name.encode("UTF-16BE")
      len = x.size

      @directories.each do |e|
        if e.name == ""
          next
        end

        #
        # need to trim the directory name to (len - 1)
        # to do comparison
        #
        name_utf16 = e.name.to_utf16[0..len-1]

        if name_utf16 == x
          data = read_sector(e.start_sector)
          if data.size > 0
            return true, data
          end
        end
      end

      return false, Bytes.new(0)
    end


    #
    # Dump sector (for debugging only)
    #
    def dump_sector(sector : UInt32)
      read_sector(sector)
    end
  end
end

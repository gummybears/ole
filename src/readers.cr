#
# readers.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

module Ole

  module Readers

    #
    # returns the entire contents of a chain starting at the given sector
    #
    private def read_directories(sector : UInt32)

      # old code sector_array = [] of Bytes

      #
      # keep a list of sectors we've already read
      #
      h = Hash(UInt32,UInt32).new
      h[sector] = sector

      next_sector = Ole::ENDOFCHAIN
      while true

        if sector == Ole::ENDOFCHAIN
          break
        end

        data        = read_sector(sector)
        dir_entries = directory_entries(data)

        dir_entries.each do |dir|
          @directories << dir
        end
        # old code sector_array << data

        next_sector = @fat[sector]
        # old code puts "sector #{sector} next #{next_sector}"

        if h.has_key?(next_sector)
          #
          # error, already read this sector
          #
          puts "ole warning: already read sector #{sector}"
          break
        end

        h[next_sector] = next_sector
        sector = next_sector
      end


      ## old code puts "size of buffer #{buffer.size} size of element #{buffer[0].size}"
      #return buffer
    end

    private def _read_mini_chain(sector : UInt32)

      # buffer = [] of Bytes
      #
      # #
      # # keep a list of sectors we've already read
      # #
      # h = Hash(UInt32,UInt32).new
      # h[sector] = sector
      #
      # next_sector = Ole::ENDOFCHAIN
      # while true
      #
      #   if sector == Ole::ENDOFCHAIN
      #     puts "break while loop #{sector}"
      #     break
      #   end
      #
      #   data        = read_sector(sector)
      #   next_sector = @fat[sector]
      #
      #   puts "sector #{sector} next #{next_sector}"
      #
      #
      #   if h.has_key?(next_sector)
      #     # error, already read this sector
      #     puts "already read sector #{sector}"
      #     break
      #   end
      #
      #   h[next_sector] = next_sector
      #   sector = next_sector
      # end
      #return sector
    end


    def read_mini_chain(sector : UInt32)
      #return _read_chain(sector_start,"minifat")
    end

    def read_chain(sector : UInt32)
      return _read_chain(sector)
    end

    def read_sector(index : UInt32) : Bytes
      x    = sector_size()
      spos = x * ( index + 1 )
      epos = spos + x
      @data[spos..epos - 1]
    end

  end
end

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
    # old code private def read_directories(sector : UInt32)
    #
    private def read_directories(sector : UInt32)

      # old code sector = @header.first_dir_sector

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

        next_sector = @fat[sector]
        if h.has_key?(next_sector)
          #
          # error, already read this sector
          #
          @errors << "ole warning: already read sector #{sector}"
          @status = -1
          break
        end

        h[next_sector] = next_sector
        sector = next_sector
      end

      #
      # set the root directory
      #
      set_root()

    end

    def set_root()
      @root = @directories[0]
    end

    #private
    def read_minifat_chain(sector : UInt32)

      #
      # keep a list of sectors we've already read
      #
      h = Hash(UInt32,UInt32).new
      h[sector] = sector

      # old code puts "minifat chain for sector #{sector}"

      next_sector = Ole::ENDOFCHAIN
      while true

        if sector == Ole::ENDOFCHAIN
          # old code puts "sector is end of chain"
          break
        end

        data = read_sector(sector)
        # old code puts "sector #{sector} data size #{data.size}"

        minifat_entries = read_minifat(data)
        minifat_entries.each do |e|
          @minifat << e
        end

        next_sector = @fat[sector]
        # old code puts "next sector is #{next_sector}"
        if h.has_key?(next_sector)
          #
          # error, already read this sector
          #
          @errors << "ole warning: already read sector #{sector}"
          @status = -1
          break
        end

        h[next_sector] = next_sector
        sector = next_sector
      end

    end

    # old code def read_mini_chain(sector : UInt32)
    # old code   return _read_minifat_chain()
    # old code end

    # old code def read_chain(sector : UInt32)
    # old code   return _read_chain(sector)
    # old code end

    def read_sector(index : UInt32) : Bytes
      x    = sector_size()
      spos = x * ( index + 1 )
      epos = spos + x
      @data[spos..epos - 1]
    end

    # old code def read_mini_sector(index : UInt32) : Bytes
    # old code   x    = mini_sector_size()
    # old code   spos = x * ( index + 1 )
    # old code   epos = spos + x
    # old code   @data[spos..epos - 1]
    # old code end
  end
end

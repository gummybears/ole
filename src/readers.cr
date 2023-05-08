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
    def read_directories(sector : UInt32)

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

        data = read_sector(sector)
        if data.size == 0
          set_error("no data found in chain for sector #{sector}")
          break
        end

        dir_entries = directory_entries(data)
        dir_entries.each do |dir|
          @directories << dir
        end

        next_sector = @fat[sector]
        if h.has_key?(next_sector)
          set_error("already read sector #{sector}")
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
        set_error("broken FAT, sector size is #{bytes.size} but should be #{@header.sector_size}")
        return
      end

      (0...bytes.size - 1).step(4) do |x|
        arr    = bytes[x..x+3]
        sector = ::Ole.endian_u32(arr,@header.byte_order)
        @fat << sector
      end
    end

    def read_minifat_chain(sector : UInt32)

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

        data = read_sector(sector)
        if data.size == 0
          set_error("no data found in chain for sector #{sector}")
          break
        end

        if data.size != sector_size()
          set_warning("encountered EOF while parsing minifat")
          next
        end

        minifat_entries = read_minifat(data)
        minifat_entries.each do |e|
          @minifat << e
        end

        next_sector = @fat[sector]
        if h.has_key?(next_sector)
          set_error("already read sector #{sector}")
          break
        end

        h[next_sector] = next_sector
        sector = next_sector
      end
    end

    def read_minifat_stream(sector : UInt32)

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

        data = read_sector(sector)
        if data.size == 0
          set_error("no data found in minifat stream for sector #{sector}")
          break
        end

        @ministream = read_ministream(data)

        next_sector = @fat[sector]
        if h.has_key?(next_sector)
          set_error("already read sector #{sector}")
          break
        end

        h[next_sector] = next_sector
        sector = next_sector
      end
    end

    def read_sector(index : UInt32) : Bytes
      #
      # basic checks
      #
      if index < 0
        set_error("sector cannot be negative")
        return Bytes[]
      end

      x = sector_size()
      if x < 0
        set_error("sector size cannot be negative")
        return Bytes[]
      end

      spos = x * ( index + 1 )
      epos = spos + x
      if spos < 0
        set_error("array index cannot be negative")
        return Bytes[]
      end

      if epos > @data.size
        set_error("array index exceeds size of array")
        return Bytes[]
      end

      @data[spos..epos - 1]
    end

    def read_stream(d : DirectoryEntry) : Bytes

      #
      # basic checks
      #
      if d.start_sector < 0
        set_error("sector cannot be negative")
        return Bytes[]
      end

      x    = sector_size()
      spos = x * ( d.start_sector + 1 )
      epos = spos + d.size

      if spos < 0
        set_error("array index cannot be negative")
        return Bytes[]
      end

      if epos > @data.size
        set_error("array index exceeds size of array")
        return Bytes[]
      end

      @data[spos..epos - 1]
    end

    #
    # Read the Ministream
    #
    def read_ministream(bytes : Bytes) : Bytes
      x = bytes.dup
      return x
    end

    def read_minifat(bytes : Bytes) : Array(UInt32)
      ids = [] of UInt32

      if bytes.size != @header.sector_size()
        set_error("broken mini FAT, sector size is #{bytes.size} but should be #{@header.sector_size}")
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

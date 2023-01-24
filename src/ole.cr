#
# ole.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

require "./header.cr"
require "./helper.cr"
require "./constants.cr"
require "./convert_string.cr"
require "./convert_datetime.cr"
require "./stream.cr"
require "./metadata.cr"
require "./direntry.cr"

require "./dump.cr"

#
# see https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-cfb/28488197-8193-49d7-84d8-dfd692418ccd
#
module Ole

  class FileIO

    property mode                 : String = ""
    property filename             : String = ""
    property errors               : Array(String) = [] of String
    property status               : Int32 = -1
    property header               : Ole::Header
    property size                 : Int64 = 0
    property io                   : IO
    property data                 : Bytes
    property root                 : DirectoryEntry = DirectoryEntry.new
    property fat                  : Array(UInt32) = [] of UInt32
    property direntries           : Array(DirectoryEntry) = [] of DirectoryEntry
    property byte_order           : Ole::ByteOrder = Ole::ByteOrder::None

    #property max_dir_entries      : UInt32 = 0u32

    include Dump

    def initialize(filename : String, mode : String)

      @filename = filename
      @mode     = mode
      if File.exists?(filename) == false
        @errors << "file '#{filename}' not found"
        @status = -1
        return
      end

      @status = 0
      file    = File.new(filename)
      @size   = file.size
      @io     = file
      @data   = Bytes.new(@size)
      @io.read_fully(@data)

      @header          = Header.new(@data)
      @byte_order      = @header.determine_byteorder
      #@max_dir_entries = (1024/DIRENTRY_SIZE).to_u32

      if is_valid? == false
        return
      end

      load_fat()
      load_directory(@header.first_dir_sector)

      file.close
    end

    def get_header() : Header
      @header
    end

    def is_valid? : Bool
      @header.validate
    end

    #
    # returns the sector size (@header.sector_size)
    # version 3 : 512
    # version 4 : 4096
    #
    def sector_size() : Int32
      @header.sector_size
    end

    #
    # returns the mini sector size (@header.mini_sector_size)
    #
    def mini_sector_size() : Int32
      @header.mini_sector_size
    end

    def filesize() : Int64
      @size
    end

    #
    # returns the maximun number of sectors
    #
    # Note: -1 because header doesn't count
    #
    def max_nr_sectors() : Int32
      s = sector_size()
      x = ((filesize() + s - 1)/s) - 1
      return x.to_i32
    end

    #
    # Load the FAT table
    #
    def load_fat()
      # bytes = @data[76..@header.size-1]
      #load_fat_sector(bytes)
      (0..@header.nr_fat_sectors - 1).each do |sector|
        load_fat_sector(sector.to_u32)
      end
    end

    #
    # first convert the raw data into decoded sector indices
    # the raw data contains Little Endian encoded sector indices
    # 4 bytes long
    #
    def load_fat_sector(sector : UInt32) # bytes : Bytes)

      # (0..bytes.size-1).step(4) do |x|
      #
      #   #
      #   # process 4 bytes
      #   #
      #   arr          = bytes[x..x+3]
      #   sector_index = ::Ole.endian_u32(arr,@header.byte_order)
      #   if sector_index == Ole::ENDOFCHAIN || sector_index == Ole::FREESECT
      #     break
      #   end
      #
      #   puts "index #{sector_index.to_s(16)}"
      #   @fat << sector_index
      #
      #   #
      #   # get the next sector index (if any)
      #   #
      #   arr = get_sector(sector_index)
      #   next_sector_index = ::Ole.endian_u32(arr,@header.byte_order)
      #   @fat << next_sector_index
      #
      # end

      bytes = get_sector(sector)

      #
      # Iterate through the FAT and print the sector numbers
      #
      (0...bytes.size - 1).step(4) do |x|
        arr          = bytes[x..x+3]
        sector_index = ::Ole.endian_u32(arr,@header.byte_order)
        # if sector_index == Ole::ENDOFCHAIN || sector_index == Ole::FREESECT
        #   break
        # end

        @fat << sector_index
        puts "index #{sector_index.to_s(16)}"
      end

    end

    def get_sector(index : UInt32) : Bytes

      x    = sector_size()
      spos = x * ( index + 1 )
      epos = spos + x
      @data[spos..epos - 1]
    end

    #
    # Load the directory given by sector index
    # of directory stream
    #
    def load_directory(sector : UInt32)

      offset   = @header.size.to_u32
      direntry = get_directory_entry(sector,offset)

      #
      # add direntry to array
      #
      @direntries << direntry
      @root = @direntries[0]

    end

    #
    # decode and return a directory entry
    #
    def get_directory_entry(sector : UInt32, offset : UInt32) : Ole::DirectoryEntry

      spos = offset + sector_size() * sector
      epos = spos   + DIRENTRY_SIZE

      x        = @data[spos..epos - 1]
      direntry = Ole::DirectoryEntry.new(x,@byte_order)
      return direntry
    end

    #
    # returns the Root directory entry
    #
    def get_root_entry() : Ole::DirectoryEntry
      @root
    end

  end
end

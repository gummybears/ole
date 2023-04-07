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
require "./directory.cr"
require "./fat.cr"
require "./minifat.cr"
require "./readers.cr"


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
    property minifat              : Array(UInt32) = [] of UInt32
    property directories          : Array(DirectoryEntry) = [] of DirectoryEntry
    property byte_order           : Ole::ByteOrder = Ole::ByteOrder::None
    property fat_sectors          : Array(UInt32) = [] of UInt32

    include Dump
    include Directory
    include Fat
    include MiniFat
    include Readers

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

      if is_valid? == false
        return
      end

      read_fat()
      read_directories(@header.first_dir_sector)

      if @directories[0].start_sector != Ole::ENDOFCHAIN
        read_ministream()
        read_minifat(@header.first_mini_fat_pos)
      end

      file.close
    end

    def get_header() : Header
      @header
    end

    def is_valid? : Bool
      @header.validate
    end

    def sector_size() : Int32
      @header.sector_size()
    end

    #
    # returns the mini sector size (@header.mini_sector_size)
    #
    def minifat_sector_size() : Int32
      @header.minifat_sector_size()
    end

    # def minifat_sector_size() : Int32
    #   @header.minifat_sector_size
    # end


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
      x = ((@size + s - 1)/s) - 1
      return x.to_i32
    end

  end
end

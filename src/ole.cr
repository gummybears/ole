#
# ole.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

require "./header.cr"
require "./helper.cr"
#
# see https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-cfb/28488197-8193-49d7-84d8-dfd692418ccd
#
module Ole

  class FileIO

    property mode     : String
    property filename : String
    property error    : String = ""
    property status   : Int32 = -1
    property header   : Ole::Header

    # size of file
    property size     : Int64
    property io       : IO
    property data     : Bytes

    property used_streams_fat     : Array(Int32) = [] of Int32
    property used_streams_minifat : Array(Int32) = [] of Int32

    def initialize(filename : String, mode : String)

      @filename = filename
      @mode     = mode
      if File.exists?(filename) == false
        @error = "file '#{filename}' not found"
        @status = -1
      end

      @status = 0

      file    = File.new(filename)
      @size   = file.size
      @io     = file

      @data   = Bytes.new(@size)
      @io.read_fully(@data)
      @header = Header.new(@data)
    end

    def read_fat()
      #
      # check known streams for duplicate references
      # these are always in FAT,never in MiniFAT
      #
      check_duplicate_stream()

      #
      # check MiniFAT only if it is not empty
      #
      if nr_mini_fat_sectors() > 0
        #
        #
        #
        check_duplicate_stream(first_mini_fat_sector())
      end

      #
      # check DIFAT only if it is not empty
      #
      if nr_difat_sectors()
          check_duplicate_stream() # first_difat_sector)
      end

      #
      # Load file allocation tables
      #
      loadfat()
    end

    #
    # Checks if a stream has not been already referenced elsewhere.
    # This method should only be called once for each known stream, and only
    # if stream size is not null.
    #
    # first_sect : int  , index of first sector of the stream in FAT
    # minifat    : bool , if True, stream is located in the MiniFAT, else in the FAT
    #

    def check_duplicate_stream(first_sector : Int32, minifat : Bool = false)
        # if minifat:
        #     log.debug('_check_duplicate_stream: sect=%Xh in MiniFAT' % first_sect)
        #     used_streams = self._used_streams_minifat
        # else:
        #     log.debug('_check_duplicate_stream: sect=%Xh in FAT' % first_sect)
        #     # some values can be safely ignored (not a real stream):
        #     if first_sect in (DIFSECT,FATSECT,ENDOFCHAIN,FREESECT):
        #         return
        #     used_streams = self._used_streams_fat
        # # TODO: would it be more efficient using a dict or hash values, instead
        # #      of a list of long ?
        # if first_sect in used_streams:
        #     self._raise_defect(DEFECT_INCORRECT, 'Stream referenced twice')
        # else:
        #     used_streams.append(first_sect)
    end

    def loadfat()
    end

    def get_header() : Header
      @header
    end

    def is_valid? : Bool
      @header.validate
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
    end

    #
    # Returns directory entry of given filename. (openstream helper)
    # Note: this method is case-insensitive.
    #
    # filename: path of stream in storage tree (except root entry), either:
    #
    #     - a string using Unix path syntax, for example:
    #       'storage_1/storage_1.2/stream'
    #     - or a list of storage filenames, path to the desired stream/storage.
    #       Example: ['storage_1', 'storage_1.2', 'stream']
    #
    # returns   : sid of requested filename
    # exception : file not found
    #
    def find(filename : String) : Bool
      r = false
      r
    end
    #
    #  Test if given filename exists as a stream or a storage in the OLE
    #  container.
    #  Note: filename is case-insensitive.
    #
    def stream_exists?(name : String) : Bool
      r = find(name)
      r
    end

  end
end

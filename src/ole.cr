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
    property fat                  : Array(Int32) = [] of Int32

    property max_dir_entries      : UInt32 = 0u32
    property direntries           : Array(DirectoryEntry) = [] of DirectoryEntry
    property byte_order           : Ole::ByteOrder = Ole::ByteOrder::None

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
      @max_dir_entries = (1024/DIRENTRY_SIZE).to_u32

      if is_valid? == false
        return
      end

      load_directory(@header.first_dir_sector)


      file.close
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
      if @header.nr_mini_fat_sectors() > 0
        #
        #
        #
        check_duplicate_stream(first_mini_fat_sector())
      end

      #
      # check DIFAT only if it is not empty
      #
      if @header.nr_difat_sectors()
        check_duplicate_stream() # first_difat_sector)
      end

      #
      # Load file allocation table
      #
      load_fat()
    end

    #
    # Open a stream, either in FAT or MiniFAT according to its size.
    # (openstream helper)
    #
    # start     : index of first sector
    # size      : size of stream or -1 if size is unknown
    # force_fat : if false (default), stream will be opened in FAT or MiniFAT
    #             according to size. If true, it will always be opened in FAT.
    #
    def open_stream(start : Int32, size = UNKNOWN_SIZE, force_fat : Bool = false) : Ole::Stream

      #
      # stream size is compared to the mini_stream_cutoff_size threshold
      #
      if size < @header.mini_stream_cutoff && !force_fat

        # TODO #
        # TODO # ministream object
        # TODO #
        # TODO if @ministream == false
        # TODO
        # TODO   #
        # TODO   # load mini FAT
        # TODO   #
        # TODO   load_minifat()
        # TODO
        # TODO   #
        # TODO   # The first sector index of the mini FAT stream is stored in the root directory entry
        # TODO   #
        # TODO   size_ministream = @root.size
        # TODO   ministream = open_stream(@root.isectStart, size_ministream, true)
        # TODO
        # TODO   #return OleStream(fp=self.ministream, sect=start, size=size,
        # TODO   #               offset=0, sectorsize=self.minisectorsize,
        # TODO   #               fat=self.minifat, filesize=self.ministream.size,
        # TODO   #               olefileio=self)
      else

        # standard stream
        # return OleStream(fp=self.fp, sect=start, size=size,   offset=self.sectorsize, sectorsize=self.sectorsize, fat=self.fat, filesize=self._filesize, olefileio=self)

      end

    end

    #
    # Open a stream as a read-only file object
    # filename : path of stream in storage tree (except root entry)
    #
    # returns : file object
    #
    # Note : filename is case-insensitive.
    #
    def open_stream(name : String)

    end

    #
    # Open a stream as a read-only file object
    # filenames : array of filenames like ['storage_1', 'storage_1.2', 'stream']
    #
    # returns : file object
    #
    # Note : filename is case-insensitive.
    #
    def open_stream(filenames : Array(String))
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
    # returns the maximun sector size for this file
    #
    # Note: -1 because header doesn't count
    #
    def max_nr_sectors() : Int32
      s = sector_size()
      x = ((@size + s - 1)/s) - 1
      return x.to_i32
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
      epos = spos + DIRENTRY_SIZE

      x    = @data[spos..epos-1]
      direntry = Ole::DirectoryEntry.new(x,@byte_order)
      return direntry
    end

    #
    # returns the Root directory entry
    #
    def get_root_entry() : Ole::DirectoryEntry
      @root
    end

#################### All code after this comment is not used/untested ####################################################

    # TODO ?? #
    # TODO ?? #
    # TODO ?? # given a sector index, returns sector data as a string
    # TODO ?? #
    # TODO ?? def get_sector(sector : Int32)
    # TODO ?? end
    # TODO ??
    # TODO ?? #
    # TODO ?? # Write given sector to file on disk.
    # TODO ?? # given a sector index, sector data and some padding
    # TODO ?? # Note: padding is single byte, only needed if data < sector size
    # TODO ?? #
    # TODO ?? def write_sector(sector : Int32, data : Bytes, padding : String ="0x00")
    # TODO ?? end
    # TODO ??
    # TODO ?? #
    # TODO ?? # Write given sector to file on disk.
    # TODO ?? #
    # TODO ?? # pos     : file position
    # TODO ?? # data    : bytes, sector data
    # TODO ?? # padding : single byte, padding character if data < sector size
    # TODO ?? #
    # TODO ?? def write_mini_sector(pos : Int32, data : Bytes, padding : String = "0x0")
    # TODO ?? end
    # TODO ??
    # TODO ?? #
    # TODO ?? # Load the FAT table
    # TODO ?? #
    # TODO ?? def load_fat()
    # TODO ?? end
    # TODO ??
    # TODO ?? #
    # TODO ?? # Adds the indexes of the given sector to the FAT
    # TODO ?? #
    # TODO ?? # sector  : index containing the first FAT sector
    # TODO ?? # returns : index of last FAT sector.
    # TODO ?? #
    # TODO ?? def load_fat_sector(sector : Int32)
    # TODO ?? end
    # TODO ??
    # TODO ?? #
    # TODO ?? # Adds the indexes of the given sector to the FAT
    # TODO ?? #
    # TODO ?? # sector  : array of long integers
    # TODO ?? # returns : index of last FAT sector.
    # TODO ?? #
    # TODO ?? #
    # TODO ?? def load_fat_sector(sector : Array(Int32))
    # TODO ?? end
    # TODO ??
    # TODO ?? #
    # TODO ?? # Load the MiniFAT table
    # TODO ?? #
    # TODO ?? # The MiniFAT table is stored in a standard sub-stream, pointed to by a header
    # TODO ?? # field.
    # TODO ?? #
    # TODO ?? def load_minifat()
    # TODO ?? end
    # TODO ??
    # TODO ?? #
    # TODO ?? # Returns directory entry of given filename. (openstream helper)
    # TODO ?? # Note: this method is case-insensitive.
    # TODO ?? #
    # TODO ?? # filename: path of stream in storage tree (except root entry), either:
    # TODO ?? #
    # TODO ?? #     - a string using Unix path syntax, for example:
    # TODO ?? #       'storage_1/storage_1.2/stream'
    # TODO ?? #     - or a list of storage filenames, path to the desired stream/storage.
    # TODO ?? #       Example: ['storage_1', 'storage_1.2', 'stream']
    # TODO ?? #
    # TODO ?? # returns   : sid of requested filename
    # TODO ?? # exception : file not found
    # TODO ?? #
    # TODO ?? def find(name : String) : {Bool, Int32}
    # TODO ??   return false, 0
    # TODO ?? end
    # TODO ??
    # TODO ?? #
    # TODO ?? #  Test if given name exists as a stream or a storage in the OLE
    # TODO ?? #  container.
    # TODO ?? #
    # TODO ?? #  Note: name is case-insensitive.
    # TODO ?? #
    # TODO ?? def stream_exists?(name : String) : Bool
    # TODO ??   found, r = find(name)
    # TODO ??   return found
    # TODO ?? end
    # TODO ??
    # TODO ?? #
    # TODO ?? # name    : path of stream in storage tree
    # TODO ?? # returns : size of a stream in the OLE container, in bytes.
    # TODO ?? #
    # TODO ?? def get_stream_size(name : String) : UInt32
    # TODO ??
    # TODO ??   found, sid = find(name)
    # TODO ??   if found
    # TODO ??     entry = direntries[sid]
    # TODO ??     if entry.type != Ole::Storage::Stream
    # TODO ??       return 0u32
    # TODO ??     end
    # TODO ??
    # TODO ??     return entry.size
    # TODO ??   end
    # TODO ??
    # TODO ??   return 0u32
    # TODO ?? end
    # TODO ??
    # TODO ?? def get_metadata() : Ole::MetaData
    # TODO ??   Ole::MetaData.new
    # TODO ?? end
    # TODO ??
    # TODO ?? #
    # TODO ?? # Test if given filename exists as a stream or a storage in the OLE
    # TODO ?? # container, and return its type.
    # TODO ?? #
    # TODO ?? # filename : path of stream in storage tree
    # TODO ?? # returns  : false if object does not exist, its entry type (>0) otherwise
    # TODO ?? #
    # TODO ?? # STGTY_STREAM  : a stream
    # TODO ?? # STGTY_STORAGE : a storage
    # TODO ?? # STGTY_ROOT    : the root entry
    # TODO ?? #
    # TODO ?? def get_stream_type(filename : String) : Bool
    # TODO ??   r = false
    # TODO ??   #  try:
    # TODO ??   #      sid = self._find(filename)
    # TODO ??   #      entry = self.direntries[sid]
    # TODO ??   #      return entry.entry_type
    # TODO ??   #  except Exception:
    # TODO ??   #
    # TODO ??   #
    # TODO ??   return r
    # TODO ?? end
    # TODO ??
    # TODO ?? def list_directories() : Array(String)
    # TODO ??   s = [] of String
    # TODO ??   s
    # TODO ?? end
  end
end

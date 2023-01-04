#
# ole.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

require "./header.cr"
require "./helper.cr"
require "./constants.cr"
require "./stream.cr"
require "./metadata.cr"
require "./direntry.cr"

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

    property fat      : Array(Int32) = [] of Int32

    property used_streams_fat     : Array(Int32) = [] of Int32
    property used_streams_minifat : Array(Int32) = [] of Int32

    property max_dir_entries      : UInt32 = 0u32
    property direntries           : Array(DirectoryEntry) = [] of DirectoryEntry
    property root                 : DirectoryEntry

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
      @max_dir_entries = (1024/DIRENTRY_SIZE).to_u32

      if is_valid? == false
        return
      end

      # is not doing anything yet
      load_directory(@header.first_dir_sector)

      #
      # load the root directory entry starting at offset 1024
      # ie skip the header and the FAT
      #
      @root = load_directory_entry(0)

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
    # dump some header information
    # debug purposes
    #
    def dump
      puts
      puts "dump of file #{@filename}"
      puts
      @header.dump()
      dump_fat()
    end

    #
    # Dump directory (for debugging only)
    #
    def dump_directory
      # @root.dump()
    end

    #
    # Dump FAT (for debugging only)
    #
    def dump_fat

      puts
      puts "dump FAT"
      puts

      x = @header.nr_fat_sectors
      if x == 0
        return
      end

      startpos      = @header.sector_size
      nr_fat_fields = @header.nr_fat_fields
      byte_order    = Ole::ByteOrder::LittleEndian

      #
      # read 4 bytes at a time
      #
      spos = startpos
      epos = startpos + nr_fat_fields
      (spos..epos).step(4).each do |i|
        spos = i
        epos = spos + 4 - 1

        d = @data[spos..epos]
        v = ::Ole.to_hex(d,byte_order,true)
        puts "0x#{i.to_s(16)} : #{v}"
      end
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
    # Dump sector (for debugging only)
    #
    def dump_sector(sector : Int32, first_index : Int32 = 0)
    end

    #
    # Load the directory given by sector index
    # of directory stream
    #
    def load_directory(sector : UInt32)
    end

    #
    # Load a directory entry from the directory.
    # This method should only be called once for each storage/stream when
    # loading the directory.
    #
    # Sid is the index of storage/stream in the directory.
    # and returns a DirectoryEntry object
    #
    # Error: if the entry has always been referenced.
    #
    def load_directory_entry(sid : UInt32) : Ole::DirectoryEntry

      spos = 1024 + sid * DIRENTRY_SIZE
      epos = spos + DIRENTRY_SIZE
      data = @data[spos..epos-1]

      direntry = Ole::DirectoryEntry.new(data,sid)
      return direntry
      #  self.directory_fp.seek(sid * 128)
      #  entry = self.directory_fp.read(128)
      #  self.direntries[sid] = OleDirectoryEntry(entry, sid, self)
      #  return self.direntries[sid]

    end


    #
    # Read given sector from file on disk
    # given a sector index, returns sector data as a string
    #
    def get_sector(sector : Int32)
    end

    #
    # Write given sector to file on disk.
    # given a sector index, sector data and some padding
    # Note: padding is single byte, only needed if data < sector size
    #
    def write_sector(sector : Int32, data : Bytes, padding : String ="0x00")
    end

    #
    # Write given sector to file on disk.
    #
    # pos     : file position
    # data    : bytes, sector data
    # padding : single byte, padding character if data < sector size
    #
    def write_mini_sector(pos : Int32, data : Bytes, padding : String = "0x0")
    end

    #
    # Load the FAT table
    #
    def load_fat()
    end

    #
    # Adds the indexes of the given sector to the FAT
    #
    # sector  : index containing the first FAT sector
    # returns : index of last FAT sector.
    #
    def load_fat_sector(sector : Int32)
    end

    #
    # Adds the indexes of the given sector to the FAT
    #
    # sector  : array of long integers
    # returns : index of last FAT sector.
    #
    #
    def load_fat_sector(sector : Array(Int32))
    end

    #
    # Load the MiniFAT table
    #
    # The MiniFAT table is stored in a standard sub-stream, pointed to by a header
    # field.
    #
    def load_minifat()
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
    def find(name : String) : {Bool, Int32}
      return false, 0
    end

    #
    #  Test if given name exists as a stream or a storage in the OLE
    #  container.
    #
    #  Note: name is case-insensitive.
    #
    def stream_exists?(name : String) : Bool
      found, r = find(name)
      return found
    end

    #
    # name    : path of stream in storage tree
    # returns : size of a stream in the OLE container, in bytes.
    #
    def get_stream_size(name : String) : UInt32

      found, sid = find(name)
      if found
        entry = direntries[sid]
        if entry.type != Ole::Storage::Stream
          return 0u32
        end

        return entry.size
      end

      return 0u32
    end

    def get_metadata() : Ole::MetaData
      Ole::MetaData.new
    end

    #
    # Test if given filename exists as a stream or a storage in the OLE
    # container, and return its type.
    #
    # filename : path of stream in storage tree
    # returns  : false if object does not exist, its entry type (>0) otherwise
    #
    # STGTY_STREAM  : a stream
    # STGTY_STORAGE : a storage
    # STGTY_ROOT    : the root entry
    #
    def get_stream_type(filename : String) : Bool
      r = false
      #  try:
      #      sid = self._find(filename)
      #      entry = self.direntries[sid]
      #      return entry.entry_type
      #  except Exception:
      #
      #
      return r
    end

    def list_directories() : Array(String)
      s = [] of String
      s
    end

    #
    # returns the Root directory entry
    #
    def get_root_entry() : Ole::DirectoryEntry
      @root
    end
  end
end

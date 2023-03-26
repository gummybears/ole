#
# directory.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

module Ole

  module Directory

    # old code #
    # old code # Load the directory given by sector index
    # old code # of directory stream
    # old code #
    # old code def load_directory(sector : UInt32)
    # old code
    # old code   offset   = @header.size.to_u32
    # old code   direntry = get_directory_entry(sector,offset)
    # old code
    # old code   #
    # old code   # add direntry to array
    # old code   #
    # old code   @directories << direntry
    # old code   @root = @directories[0]
    # old code end

    # old code #
    # old code # decode and return a directory entry
    # old code #
    # old code # 21-03-2023, wrong code
    # old code #
    # old code def get_directory_entry(sector : UInt32, offset : UInt32) : Ole::DirectoryEntry
    # old code   spos = offset + sector_size() * sector
    # old code   size = Ole::DirectoryEntry.size
    # old code   epos = spos + size
    # old code
    # old code   x        = @data[spos..epos - 1]
    # old code   direntry = Ole::DirectoryEntry.new(x,@byte_order)
    # old code   return direntry
    # old code end

    # old code def load_directories()
    # old code
    # old code   # dir_entry_size   = Ole::DirectoryEntry.size
    # old code   # @max_dir_entries = 0
    # old code
    # old code   read_directories(@header.first_dir_sector)
    # old code
    # old code end

    def directory_entries(data : Bytes) : Array(Ole::DirectoryEntry)

      dir_entries = [] of Ole::DirectoryEntry
      dir_size    = Ole::DirectoryEntry.size
      data_size   = data.size
      nr_entries  = (data_size/dir_size).to_i
      # old code puts "nr #{nr_entries}"

      #
      # The array data holds 1 sector (size 512 or greater)
      # a directory entry is 128 bytes in size so we could have
      # 4 directory entries per sector
      #

      (0..nr_entries - 1).each do |index|
        spos      = index * dir_size
        epos      = spos + dir_size
        x         = data[spos..epos - 1]
        # old code  puts "data size #{data.size} index #{index} spos #{spos} epos #{epos - 1} dir #{dir_size}"
        dir_entry = Ole::DirectoryEntry.new(x,@byte_order)

        dir_entries << dir_entry
      end

      return dir_entries
    end

    #
    # returns the Root directory entry
    #
    def get_root_entry() : Ole::DirectoryEntry
      @root
    end
  end
end

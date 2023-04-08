#
# directory.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

module Ole

  module Directory

    def directory_entries(data : Bytes) : Array(Ole::DirectoryEntry)

      dir_entries = [] of Ole::DirectoryEntry
      dir_size    = Ole::DirectoryEntry.size
      data_size   = data.size
      nr_entries  = (data_size/dir_size).to_i

      #
      # The array data holds 1 sector (size 512 or greater)
      # a directory entry is 128 bytes in size so we could have
      # 4 directory entries per sector
      #
      (0..nr_entries - 1).each do |index|
        spos      = index * dir_size
        epos      = spos + dir_size
        x         = data[spos..epos - 1]
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

    def set_root()
      @root = @directories[0]
    end
  end
end

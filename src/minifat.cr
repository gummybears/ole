#
# minifat.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

module Ole

  module MiniFat

    #
    # Load the Mini FAT table
    #
    def load_minifat()

    end

    #
    # returns the mini sector size (@header.mini_sector_size)
    #
    def minifat_sector_size() : Int32
      @header.minifat_sector_size
    end

  end
end

#
# sector.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

module Ole

  class Sector
    property data : Bytes = Bytes.new(0)

    def initialize
    end

    def initialize(data : Bytes)
      @data = data.dup
    end

    def dump
      @data
    end
  end

end

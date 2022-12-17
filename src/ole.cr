require "./header.cr"
require "./helper.cr"
#
# see https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-cfb/28488197-8193-49d7-84d8-dfd692418ccd
#
module Ole

  class Storage

    property mode     : String
    property filename : String
    property error    : String = ""
    property status   : Int32 = -1
    property header   : Ole::Header

    # size of file
    property size     : Int64
    property io       : IO
    property data     : Bytes

    def initialize(filename : String, mode : String)

      @filename = filename
      @mode     = mode
      if File.exists?(filename) == false
        @error = "file #{filename} not found"
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

    def get_header() : Header
      @header
    end
  end
end

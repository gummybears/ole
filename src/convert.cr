#
# convert.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
#
require "./helper.cr"
require "./constants.cr"

#
# Converts a slice of bytes (Little Endian coded)
# into a string
#
module Ole
  class Convert

    property arr        : Array(UInt16) = [] of UInt16
    property bytes      : Bytes
    property size       : UInt32
    property byte_order : Ole::ByteOrder

    def initialize(bytes : Bytes, size : UInt32, byte_order)

      @bytes      = bytes
      @size       = size
      @byte_order = byte_order
    end

    def make_even()

      (0..@bytes.size-1).each do |i|
        @arr << @bytes[i].to_u16
      end

      if @bytes.size % 2 != 0
        @arr << 0_u16
      end

      #
      # if the size of the new array is less
      # than the requested size
      # enlarge ie pad the array utf with zero's
      #

      if @arr.size < @size
        diff = @size - @arr.size
        (0..diff-1).each do
          @arr << 0_u16
        end
      end
    end

    def swap()

      utf16 = [] of UInt16
      (0..@arr.size-1).step(2) do |i|

        utf16 << @arr[i+1]
        utf16 << @arr[i]
      end

      @arr = utf16.clone

    end

    private def to_slice(arr)
      Slice.new(arr.size) {|i| arr[i]}
    end


    def get_array()
      @arr
    end

    def to_s() : String
      make_even()
      swap()
      x = to_slice(@arr)
      String.from_utf16(x)
    end
  end
end

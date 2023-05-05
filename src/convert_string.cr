#
# convert_string.cr
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
  class ConvertString

    property arr        : Array(UInt16)  = [] of UInt16
    property bytes      : Bytes          = Bytes[0]
    property size       : UInt32         = 0u32
    property byte_order : Ole::ByteOrder = Ole::ByteOrder::None

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
      s = String.from_utf16(x)
      return s
    end
  end
end

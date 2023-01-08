#
# convert_datetime.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
require "./helper.cr"
require "./constants.cr"

#
# Converts a slice of bytes (Little Endian coded)
# into a string
#
module Ole
  class ConvertDateTime

    property bytes      : Bytes          = Bytes[0]
    property size       : UInt32         = 0u32
    property byte_order : Ole::ByteOrder = Ole::ByteOrder::None

    def initialize(bytes : Bytes, size : UInt32, byte_order)

      @bytes      = bytes
      @size       = size
      @byte_order = byte_order
    end

    def to_datetime() : Time

      # # assume the bytes array is already in little endian format
      # (0..@bytes.size-1).each do |i|
      #   @arr << @bytes[i].to_u16
      # end
      #
      # # #
      # # # step 1 : need to swap bytes (Little Endian)
      # # #
      # # swap()
      #
      # # #
      # # # now convert the values to a 64 bit value
      # # #
      # #
      # # s = ""
      # # a = ""
      # # (0..@arr.size-1).each do |i|
      # #   a = sprintf("%0.2x",@arr[i])
      # #   s = s + a
      # #
      # #   puts "i #{i} a #{a}"
      # # end
      # # puts "s #{s}"
      # # #t0 = 0xa50103e4d5c2009cu64
      # # #puts "t0 #{t0} #{t0.to_s(10)}"
      # #
      # # t0 =      @arr[0].to_u64 * 268435456u64
      # # puts "1) t0 #{t0} #{arr[0].to_s(16)}"
      # # t0 = t0 + @arr[1].to_u64 * 16777216u64
      # # puts "2) t0 #{t0} #{arr[1].to_s(16)}"
      # #
      # # t0 = t0 + @arr[2].to_u64 * 1048576u64
      # # puts "3) t0 #{t0}"
      # #
      # # t0 = t0 + @arr[3].to_u64 * 65536u64
      # # puts "4) t0 #{t0}"
      # #
      # # t0 = t0 + @arr[4].to_u64 * 4096u64
      # # puts "5) t0 #{t0}"
      # #
      # # t0 = t0 + @arr[5].to_u64 * 256u64
      # # puts "6) t0 #{t0}"
      # #
      # # t0 = t0 + @arr[6].to_u64 * 16u64
      # # t0 = t0 + @arr[7].to_u64
      # #
      # # puts t0
      #
      # #
      # # step 2 : Fractional amount of a second is rfrac = t0 modulo 10,000,000
      # #
      # rfrac = t0 % 1000000
      #
      # #
      # # step 3 : Remaining entire seconds
      # #
      # t1 = t0 / 1000000
      #
      # #
      # # step 4 : Seconds in a minute
      # #
      # rsec = t1 %  60
      #
      # #
      # # step 5 : Remaining entire minutes
      # #
      # t2 = t1 / 60
      #
      # #
      # # step 6 : Minutes in an hour
      # #
      # rmin = t2 % 60
      #
      # #
      # # step 7 : Remaining entire hours
      # #
      # t3 = t2 / 60
      #
      # #
      # # step 8 : Hours in a day
      # #
      # rhour = t3 % 24
      #
      # #
      # # step 9 : Remaining entire days
      # #
      # t4 = t3 / 24
      #
      # #
      # # step 10 : Entire years from 1601-Jan-015
      # #
      # t5 = t4 /
      # ryear = 1601 + number of full years in t4
      Time.local
    end
  end
end

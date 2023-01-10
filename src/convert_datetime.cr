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

    property bytes   : Bytes = Bytes[0]
    property day     : Int32 = 0
    property month   : Int32 = 0
    property year    : Int32 = 0
    property hours   : Int32 = 0
    property minutes : Int32 = 0
    property seconds : Int32 = 0

    def initialize(bytes : Bytes)
      @bytes = bytes
      to_datetime()
    end

    def reverse() : Bytes
      x = @bytes.clone
      x.reverse!

      #to_datetime()
    end

    #def to_u64(bytes : Bytes) : UInt64
    #  IO::ByteFormat::BigEndian.decode(UInt64, bytes)
    #end

    def to_u64() : UInt64
      x = reverse()
      IO::ByteFormat::BigEndian.decode(UInt64, x)
    end

    #
    # calls to_u64
    #
    def to_datetime() # : Time

      #
      # to_u64 calls reverse and returns a BigEndian encoded u64 value
      # Note: should make the other methods private
      #       will do that after more tests
      #
      t0 = to_u64()

      #
      # step 1 : Fractional amount of a second is rfrac = t0 modulo 10,000,000
      #
      rfrac = t0 % TEN_MILLION # 10_000_000

      #
      # step 2 : Remaining entire seconds
      #
      t1 = t0 / TEN_MILLION # 10_000_000

      #
      # step 3 : Seconds in a minute
      #
      rsec     = t1 % 60
      @seconds = rsec.to_i

      #
      # step 4 : Remaining entire minutes
      #
      t2 = t1 / 60

      #
      # step 5 : Minutes in an hour
      #
      rmin = t2 % 60
      @minutes = rmin.to_i

      #
      # step 6 : Remaining entire hours
      #
      t3 = t2 / 60
      puts "t3 #{t3}"

      #
      # step 7 : Hours in a day
      #
      rhour  = t3 % 24
      @hours = rhour.to_i
      puts "hours #{@hours}"

      #
      # step 8 : Remaining entire days
      #
      t4 = t3 / 24
      puts "t4 #{t4}"

      #
      # step 9 : Entire years since 01-Jan-1601
      #
      # t5 = t4 /
      # ryear = 1601 + number of full years in t4

      # Time.local
    end

    def to_s() : String
      Time.local.to_s()
    end
  end
end

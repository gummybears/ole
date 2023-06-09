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
    end

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

      #
      # step 7 : Hours in a day
      #
      rhour  = t3 % 24
      @hours = rhour.to_i

      #
      # step 8 : Remaining entire days
      #
      t4 = t3 / 24

      #
      # step 9 : Entire years since 01-Jan-1601
      #
      x = (t4 / 365.25).to_i
      @year = x + YEAR_1601

      #
      # step 10 : remaining days in year
      #
      nr_days_since_1601 = (Time.utc(@year,1,1) - Time.utc(YEAR_1601,1,1)).days.to_i
      t5 = (t4 - nr_days_since_1601).to_i

      nr_full_months = t5 / 30
      @month = 1 + nr_full_months.to_i

      #
      # step 11 : remaining days in month
      #
      nr_remaining_days_in_month = (Time.utc(@year,@month,1) - Time.utc(@year,1,1)).days.to_i
      t6 = (t5 - nr_remaining_days_in_month).to_i
      @day = 1 + t6
    end

    #
    # if time = 01-01-1601, returns Time.utc
    # else return the time as computed
    #
    def to_time : Time
      t1 = Time.utc(YEAR_1601,1,1)
      t2 = Time.utc(@year,@month,@day)
      if t1 == t2
        return t1
      end

      return Time.utc(@year,@month,@day,@hours,@minutes,@seconds)

    end

    def to_s() : String
      to_time.to_s()
    end
  end
end

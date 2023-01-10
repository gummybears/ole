#
# t_convert_datetime_spec.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
require "./spec_helper"

describe "Ole::ConvertDateTime" do

  it "reverse" do
    x = datetime_bigendian_64
    c = Ole::ConvertDateTime.new(x)
    c.reverse.should eq Bytes[1, 165, 228, 3, 194, 213, 156, 0]
  end

  it "to_u64" do
    x = datetime_bigendian_64
    c = Ole::ConvertDateTime.new(x)

    # to_u64 calls reverse
    #                    118,751,670,000,000,000
    c.to_u64().should eq 118751670000000000
  end

  it "seconds" do
    # x = Bytes[ 0x80, 0x1E, 0x92, 0x13, 0x4B, 0xB4, 0xBA, 0x01]
    x = datetime_bigendian_64
    c = Ole::ConvertDateTime.new(x)
    c.seconds.should eq 0
  end

  it "minutes" do
    # x = Bytes[ 0x80, 0x1E, 0x92, 0x13, 0x4B, 0xB4, 0xBA, 0x01]
    x = datetime_bigendian_64
    c = Ole::ConvertDateTime.new(x)
    c.minutes.should eq 30
  end

  it "hours" do
    # x = Bytes[ 0x80, 0x1E, 0x92, 0x13, 0x4B, 0xB4, 0xBA, 0x01]
    x = datetime_bigendian_64
    c = Ole::ConvertDateTime.new(x)
    c.hours.should eq 1
  end

  it "to_datetime" do
    # x = Bytes[ 0x80, 0x1E, 0x92, 0x13, 0x4B, 0xB4, 0xBA, 0x01]
    x = datetime_bigendian_64
    c = Ole::ConvertDateTime.new(x)
    c.to_s().should eq Time.local.to_s()
  end

  it "day" do
    # x = Bytes[ 0x80, 0x1E, 0x92, 0x13, 0x4B, 0xB4, 0xBA, 0x01]
    x = datetime_bigendian_64
    c = Ole::ConvertDateTime.new(x)
    c.day.should eq 16
  end

  it "month" do
    # x = Bytes[ 0x80, 0x1E, 0x92, 0x13, 0x4B, 0xB4, 0xBA, 0x01]
    x = datetime_bigendian_64
    c = Ole::ConvertDateTime.new(x)
    c.month.should eq 11
  end

  it "year" do
    # x = Bytes[ 0x80, 0x1E, 0x92, 0x13, 0x4B, 0xB4, 0xBA, 0x01]
    x = datetime_bigendian_64
    c = Ole::ConvertDateTime.new(x)
    c.year.should eq 1995
  end
end

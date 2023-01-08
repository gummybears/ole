#
# t_convert_datetime_spec.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
require "./spec_helper"

describe "Ole::ConvertDateTime" do

  #
  # Example:
  #
  # The time stamp value is 0x 01 A5 E4 03 C2 D5 9C 00
  # Note: byte order is not assumed but taken to be BigEndian
  #       so we need to convert the timestamp to LittleEndian
  #
  # The final result is 1977-Apr-24 01:30:00.

  #
  # Example
  # Value as found in file : 801E 9213 4BB4 BA01
  # value is in Little Endian format

  # The code will convert this value by reversing the bytes
  # Result is : 0x01BAB44B13921E80
  #
  # The datetime value is : 11/16/1995 5:43:45 PM
  #
  it "to_datetime()" do
    x = Bytes[0x01, 0xA5, 0xE4, 0x03, 0xC2, 0xD5, 0x9C, 0x00]

    c = Ole::ConvertDateTime.new(x,8,Ole::ByteOrder::LittleEndian)
    c.to_datetime().to_s().should eq Time.local.to_s()
  end

end

#
# spec_helper.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
require "spec"
require "../src/ole.cr"
require "../src/helper.cr"

def direntry()
  Bytes[82, 0, 111, 0, 111, 0, 116, 0, 32, 0, 69, 0, 110, 0, 116, 0, 114, 0, 121, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 5, 0, 255, 255, 255, 255, 255, 255, 255, 255, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 254, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0]
end

def datetime_bigendian_64
  #
  # The time stamp value is 0x01A5E403C2D59C00
  # which represents 1977-Apr-24 01:30:00.
  #
  # 01 A5 E4 03 C2 D5 9C 00 in BigEndian format,
  # but the values in OLE files are in little endian
  # so to simulate this, we reverse the bytes to get little endian
  #
  x = Bytes[0x01, 0xA5, 0xE4, 0x03, 0xC2, 0xD5, 0x9c, 0x00]
  x.reverse!
end

#   #
#   # Example :
#   # Value as found in file : 80 1E 92 13 4B B4 BA 01
#   # value is in Little Endian format
#   #
#   # The code will convert this value by reversing the bytes
#   # Result is : 0x01BAB44B13921E80
#   #
#   # The datetime value is : 11/16/1995 5:43:45 PM
#   #
#
#     # x = Bytes[ 0x80, 0x1E, 0x92, 0x13, 0x4B, 0xB4, 0xBA, 0x01]

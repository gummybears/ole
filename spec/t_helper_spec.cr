#
# t_helper_spec.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
require "./spec_helper"
require "../src/ole.cr"

describe "Ole helpers" do
  describe "to_hex" do
    it "(x,Ole::ByteOrder::None,false)" do
      x = Bytes[0x02, 0x04]
      ::Ole.to_hex(x,Ole::ByteOrder::None,false).should eq "0x24"
    end

    it "(x,Ole::ByteOrder::None,true)" do
      x = Bytes[0x02, 0x04]
      ::Ole.to_hex(x,Ole::ByteOrder::None,true).should eq "0x0204"
    end

    it "(x,Ole::ByteOrder::LittleEndian,false)" do
      x = Bytes[0x02, 0x04]
      ::Ole.to_hex(x,Ole::ByteOrder::LittleEndian,false).should eq "0x42"
    end

    it "(x,Ole::ByteOrder::LittleEndian,false)" do
      x = Bytes[0x01, 0x02, 0x03, 0x04]
      ::Ole.to_hex(x,Ole::ByteOrder::LittleEndian,false).should eq "0x4321"
    end
  end

  describe "little_endian" do
    it "(x)" do
      x = Bytes[0x34, 0x12]
      ::Ole.little_endian(x).should eq 4660
    end

    it "(x)" do
      x = Bytes[0x34, 0x12, 0x56, 0x78]
      ::Ole.little_endian(x).should eq 2018906676
    end
  end

end

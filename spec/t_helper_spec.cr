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

  describe "le_u8" do
    it "Bytes[0x34]" do
      x = Bytes[0x34]
      ::Ole.le_u8(x).should eq 52
    end
  end

  describe "le_u16" do
    it "Bytes[0x34, 0x12]" do
      x = Bytes[0x34, 0x12]
      ::Ole.le_u16(x).should eq 4660
    end
  end

  describe "le_u32" do

    it "Bytes[0x34, 0x12, 0x56, 0x78]" do
      x = Bytes[0x34, 0x12, 0x56, 0x78]
      ::Ole.le_u32(x).should eq 2018906676
    end
  end

  describe "le_u64" do
    it "Bytes[0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]" do
      x = Bytes[0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]
      ::Ole.le_u64(x).should eq 578437695752307201
    end
  end

  describe "le_utf16" do
    it "Bytes" do
      x = Bytes[82, 0, 111, 0, 111, 0, 116, 0, 32, 0, 69, 0, 110, 0, 116, 0, 114, 0, 121, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      ::Ole.le_utf16(x,20).should eq "Root Entry"
    end
  end
end

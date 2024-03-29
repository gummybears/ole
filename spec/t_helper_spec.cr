#
# t_helper_spec.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
require "./spec_helper"

describe "Ole helpers" do
  describe "to_hex" do
    it "(x,Ole::ByteOrder::None,false)" do
      x = Bytes[0x02, 0x04]
      ::Ole.to_hex(x,Ole::ByteOrder::None,"0x",false).should eq "0x24"
    end

    it "(x,Ole::ByteOrder::None,true)" do
      x = Bytes[0x02, 0x04]
      ::Ole.to_hex(x,Ole::ByteOrder::None,"0x",true).should eq "0x0204"
    end

    it "(x,Ole::ByteOrder::LittleEndian,false)" do
      x = Bytes[0x02, 0x04]
      ::Ole.to_hex(x,Ole::ByteOrder::LittleEndian,"0x",false).should eq "0x42"
    end

    it "(x,Ole::ByteOrder::LittleEndian,false)" do
      x = Bytes[0x01, 0x02, 0x03, 0x04]
      ::Ole.to_hex(x,Ole::ByteOrder::LittleEndian,"0x",false).should eq "0x4321"
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

  #describe "to_le_u8" do
  #  it "Bytes[0xFF]" do
  #    x = Bytes[0xFF]
  #    ::Ole.to_le_u8(x).should eq 52
  #  end
  #end
  #
  #describe "to_le_u16" do
  #  it "Bytes[0x34, 0x12]" do
  #    x = Bytes[0x34, 0x12]
  #    ::Ole.to_le_u16(x).should eq 4660
  #  end
  #end
  #
  #describe "to_le_u32" do
  #  it "Bytes[0x34, 0x12, 0x56, 0x78]" do
  #    x = Bytes[0x34, 0x12, 0x56, 0x78]
  #    ::Ole.to_le_u32(x).should eq 2018906676
  #  end
  #end
  #
  #describe "to_le_u64" do
  #  it "Bytes[0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]" do
  #    x = Bytes[0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]
  #    ::Ole.to_le_u64(x).should eq 578437695752307201
  #  end
  #end

end

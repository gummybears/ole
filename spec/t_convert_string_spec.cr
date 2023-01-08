#
# t_convert_string_spec.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
require "./spec_helper"

describe "Ole::ConvertString" do

  it "make_even" do
    x = Bytes[82, 0, 111]

    c = Ole::ConvertString.new(x,6,Ole::ByteOrder::LittleEndian)
    c.make_even()

    x = c.get_array()
    x.size.should eq 6
    x.should eq [82, 0, 111, 0, 0, 0]
  end

  it "make_even" do
    x = Bytes[82, 0, 111]

    c = Ole::ConvertString.new(x,10,Ole::ByteOrder::LittleEndian)
    c.make_even()

    x = c.get_array()
    x.size.should eq 10
    x.should eq [82, 0, 111, 0, 0, 0, 0, 0, 0, 0]
  end

  it "swap" do
    x = Bytes[82, 0, 111]

    c = Ole::ConvertString.new(x,4,Ole::ByteOrder::LittleEndian)

    c.make_even()
    c.swap()

    x = c.get_array()
    x.size.should eq 4
    x.should eq [0, 82, 0, 111]
  end

  it "to_s()" do
    x = Bytes[82, 0, 111, 0, 111, 0, 116, 0]

    c = Ole::ConvertString.new(x,8,Ole::ByteOrder::LittleEndian)
    c.to_s().should eq "\u0000R\u0000o\u0000o\u0000t"
  end
end

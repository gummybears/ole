#
# t_string_spec.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
require "./spec_helper"

describe "String" do

  it "to_utf8(x : Array(Char))" do
    x = ['\0', 'R', '\0', 'o', '\0', 'o', '\0', 't', '\0', ' ', '\0', 'E', '\0', 'n', '\0', 't', '\0', 'r', '\0', 'y', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0']
    c = String.to_utf8(x)
    c.should eq "Root Entry"
  end

  it "to_utf8(x : String)" do
    x = "\0R\0o\0o\0t"
    c = String.to_utf8(x)
    c.should eq "Root"
  end

end

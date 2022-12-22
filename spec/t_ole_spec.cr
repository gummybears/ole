#
# t_ole_spec.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

require "./spec_helper"
require "../src/ole.cr"

describe "Ole::FileIO" do

  it "new" do
    ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
    ole.size.should eq 61440
    ole.status.should eq 0

    ole.dump()
  end

  describe "is_valid?" do
    it "true" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.is_valid?.should eq true
    end

    it "false" do
      ole = Ole::FileIO.new("./spec/docs/flower.jpg","rb")
      ole.is_valid?.should eq false
    end
  end

  describe "stream_exists?" do
    it "true" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.stream_exists?("worddocument").should eq true
    end
  end
end

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
    ole.header.version.should eq 3
    ole.dump()
  end

  it "new" do
    ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
    ole.size.should eq 5632
    ole.status.should eq 0
    ole.header.version.should eq 3
    ole.dump()
  end

  describe "is_valid?" do
    it "true" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.header.version.should eq 3
      ole.is_valid?.should eq true
    end

    it "false" do
      ole = Ole::FileIO.new("./spec/docs/flower.jpg","rb")
      ole.header.version.should eq 0
      ole.is_valid?.should eq false
    end
  end

  describe "list_directories" do
    ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
    ole.size.should eq 5632
    ole.status.should eq 0
    ole.header.version.should eq 3
    dirs = ole.list_directories()
    #dirs.size.should eq 0
    #dirs[0].should eq "Root Entry"
  end

  describe "sector_size" do
    it "version 3 doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.header.version.should eq 3
      ole.sector_size.should eq 512
    end

    it "version 3 excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ole.header.version.should eq 3
      ole.sector_size.should eq 512
    end
  end

  describe "max_nr_sectors" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.max_nr_sectors.should eq 119
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ole.max_nr_sectors.should eq 10
    end
  end

  describe "max_dir_entries" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.max_dir_entries.should eq 8
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ole.max_dir_entries.should eq 8
    end
  end

  describe "get root_entry" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      root= ole.get_root_entry()
      root.name.should eq "Root"
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      root= ole.get_root_entry()
      root.name.should eq "Root"
    end
  end

  describe "get_stream_type" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.get_stream_type("worddocument").should eq Ole::Storage::Stream
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ole.get_stream_type("worddocument").should eq Ole::Storage::Stream
    end
  end

  describe "get_stream_size" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.get_stream_size("worddocument").should eq 10
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ole.get_stream_size("worddocument").should eq 10
    end

  end

  describe "get_metadata" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.header.version.should eq 3
      meta = ole.get_metadata()
      meta.author.should eq "Laurence Ipsum"
      meta.nr_pages.should eq 1
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ole.header.version.should eq 3
      meta = ole.get_metadata()
      meta.author.should eq "Laurence Ipsum"
      meta.nr_pages.should eq 1
    end

  end

  describe "stream_exists?" do
    it "true" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.header.version.should eq 3
      ole.stream_exists?("worddocument").should eq true
    end

    it "false" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ole.header.version.should eq 3
      ole.stream_exists?("macros/vba").should eq false
    end
  end
end

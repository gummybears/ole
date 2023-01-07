#
# t_ole_spec.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

require "./spec_helper"

describe "Ole::FileIO" do

  describe "new" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.size.should eq 61440
      ole.status.should eq 0
      ole.header.version.should eq 3
      #ole.dump()
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ole.size.should eq 5632
      ole.status.should eq 0
      ole.header.version.should eq 3
      #ole.dump()
    end

    it "not found" do
      ole = Ole::FileIO.new("notfound","rb")
      ole.size.should eq 0
      ole.status.should eq -1
      ole.errors[0].should eq "file 'notfound' not found"
      #ole.dump()
    end
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

  describe "determine byte order" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.status.should eq 0

      ole.byte_order.should eq Ole::ByteOrder::LittleEndian
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ole.status.should eq 0

      ole.byte_order.should eq Ole::ByteOrder::LittleEndian
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
      root.name.should eq "\u0000R\u0000o\u0000o\u0000t\u0000 \u0000E\u0000n\u0000t\u0000r\u0000y\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000"
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      root= ole.get_root_entry()
      root.name.should eq "\u0000R\u0000o\u0000o\u0000t\u0000 \u0000E\u0000n\u0000t\u0000r\u0000y\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000"
    end
  end

  # TODO describe "get_stream_type" do
  # TODO   it "doc" do
  # TODO     ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
  # TODO     ole.get_stream_type("worddocument").should eq Ole::Storage::Stream
  # TODO   end
  # TODO
  # TODO   it "excel" do
  # TODO     ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
  # TODO     ole.get_stream_type("worddocument").should eq Ole::Storage::Stream
  # TODO   end
  # TODO end
  # TODO
  # TODO describe "get_stream_size" do
  # TODO   it "doc" do
  # TODO     ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
  # TODO     ole.get_stream_size("worddocument").should eq 10
  # TODO   end
  # TODO
  # TODO   it "excel" do
  # TODO     ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
  # TODO     ole.get_stream_size("worddocument").should eq 10
  # TODO   end
  # TODO
  # TODO end

  # TODO describe "get_metadata" do
  # TODO   it "doc" do
  # TODO     ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
  # TODO     ole.header.version.should eq 3
  # TODO     meta = ole.get_metadata()
  # TODO     meta.author.should eq "Laurence Ipsum"
  # TODO     meta.nr_pages.should eq 1
  # TODO   end
  # TODO
  # TODO   it "excel" do
  # TODO     ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
  # TODO     ole.header.version.should eq 3
  # TODO     meta = ole.get_metadata()
  # TODO     meta.author.should eq "Laurence Ipsum"
  # TODO     meta.nr_pages.should eq 1
  # TODO   end
  # TODO
  # TODO end

  # TODO describe "list_directories" do
  # TODO   ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
  # TODO   ole.size.should eq 5632
  # TODO   ole.status.should eq 0
  # TODO   ole.header.version.should eq 3
  # TODO   dirs = ole.list_directories()
  # TODO   #dirs.size.should eq 0
  # TODO   #dirs[0].should eq "Root Entry"
  # TODO end

  # TODO describe "stream_exists?" do
  # TODO   it "true" do
  # TODO     ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
  # TODO     ole.header.version.should eq 3
  # TODO     ole.stream_exists?("worddocument").should eq true
  # TODO   end
  # TODO
  # TODO   it "false" do
  # TODO     ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
  # TODO     ole.header.version.should eq 3
  # TODO     ole.stream_exists?("macros/vba").should eq false
  # TODO   end
  # TODO end
end

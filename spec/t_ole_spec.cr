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

  describe "get root_entry" do
    it "doc" do
      ole  = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      root = ole.get_root_entry()
      root.name.should eq "\u0000R\u0000o\u0000o\u0000t\u0000 \u0000E\u0000n\u0000t\u0000r\u0000y\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000"
    end

    it "excel" do
      ole  = Ole::FileIO.new("./spec/excel/test.xls","rb")
      root = ole.get_root_entry()
      root.name.should eq "\u0000R\u0000o\u0000o\u0000t\u0000 \u0000E\u0000n\u0000t\u0000r\u0000y\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000"
    end
  end

  describe "fat" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      fat = ole.fat
      fat.should eq [4294967293, 4294967295, 4294967294, 112, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 4294967294, 113, 114, 115, 116, 4294967294, 118, 4294967294, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295]
      fat.size.should eq 128
    end

    it "excel" do
      ole  = Ole::FileIO.new("./spec/excel/test.xls","rb")
      fat = ole.fat
      fat.should eq [4294967293, 4294967295, 4294967294, 4, 5, 6, 7, 4294967294, 9, 4294967294, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295]
      fat.size.should eq 128
    end
  end

  describe "directories" do
    it "doc" do
      ole  = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      dirs = ole.directories
      dirs.size.should eq 8
      dirs[0].name.should eq "\u0000R\u0000o\u0000o\u0000t\u0000 \u0000E\u0000n\u0000t\u0000r\u0000y\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000"
      dirs[1].name.should eq "\u0000\u0001\u0000C\u0000o\u0000m\u0000p\u0000O\u0000b\u0000j\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000"
    end

    it "excel" do
      ole  = Ole::FileIO.new("./spec/excel/test.xls","rb")
      dirs = ole.directories
      dirs.size.should eq 8
      dirs[0].name.should eq "\u0000R\u0000o\u0000o\u0000t\u0000 \u0000E\u0000n\u0000t\u0000r\u0000y\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000"
      dirs[1].name.should eq "\u0000W\u0000o\u0000r\u0000k\u0000b\u0000o\u0000o\u0000k\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000"

    end
  end

  describe "minifat" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      minifat = ole.minifat
      minifat.should eq [1]
      minifat.size.should eq 128
    end

    it "excel" do
      ole  = Ole::FileIO.new("./spec/excel/test.xls","rb")
      minifat = ole.minifat
      minifat.should eq [1]
      minifat.size.should eq 128
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

  pending "max_dir_entries" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.max_dir_entries.should eq 8
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ole.max_dir_entries.should eq 8
    end
  end
end

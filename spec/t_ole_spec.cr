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
      ole.errors[0].should eq "ole error : file 'notfound' not found"
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
      minifat.should eq [1, 4294967294, 4294967294, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 4294967294, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295]
      minifat.size.should eq 128
    end

    it "excel" do
      ole  = Ole::FileIO.new("./spec/excel/test.xls","rb")
      minifat = ole.minifat
      minifat.should eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 4294967294, 29, 4294967294, 4294967294, 32, 33, 34, 4294967294, 36, 4294967294, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295]
      minifat.size.should eq 128
    end
  end

  describe "ministream" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ministream = ole.ministream
      ministream.should eq Bytes[17, 3, 0, 0, 3, 0, 116, 0, 21, 22, 144, 1, 0, 0, 84, 105, 109, 101, 115, 32, 78, 101, 119, 32, 82, 111, 109, 97, 110, 0, 12, 22, 144, 1, 2, 0, 83, 121, 109, 98, 111, 108, 0, 11, 38, 144, 1, 0, 0, 65, 114, 105, 97, 108, 0, 40, 22, 144, 1, 0, 19, 78, 105, 109, 98, 117, 115, 32, 82, 111, 109, 97, 110, 32, 78, 111, 57, 32, 76, 0, 84, 105, 109, 101, 115, 32, 78, 101, 119, 32, 82, 111, 109, 97, 110, 0, 25, 38, 144, 1, 0, 14, 78, 105, 109, 98, 117, 115, 32, 83, 97, 110, 115, 32, 76, 0, 65, 114, 105, 97, 108, 0, 66, 0, 4, 0, 1, 8, 141, 24, 0, 0, 197, 2, 0, 0, 104, 1, 0, 0, 0, 0, 171, 84, 177, 102, 0, 8, 81, 45, 0, 8, 81, 45, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 4, 0, 131, 144, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 39, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    end

    it "excel" do
      ole  = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ministream = ole.ministream
      ministream.should eq Bytes[2, 0, 0, 0, 72, 0, 0, 0, 9, 0, 0, 0, 92, 0, 0, 0, 10, 0, 0, 0, 104, 0, 0, 0, 11, 0, 0, 0, 116, 0, 0, 0, 12, 0, 0, 0, 128, 0, 0, 0, 13, 0, 0, 0, 140, 0, 0, 0, 2, 0, 0, 0, 233, 253, 0, 0, 30, 0, 0, 0, 12, 0, 0, 0, 84, 101, 115, 116, 32, 101, 120, 99, 101, 108, 32, 0, 30, 0, 0, 0, 2, 0, 0, 0, 50, 0, 0, 0, 64, 0, 0, 0, 128, 23, 180, 44, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 161, 114, 253, 97, 217, 27, 217, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 254, 255, 0, 0, 1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 213, 205, 213, 156, 46, 27, 16, 147, 151, 8, 0, 43, 44, 249, 174, 68, 0, 0, 0, 5, 213, 205, 213, 156, 46, 27, 16, 147, 151, 8, 0, 43, 44, 249, 174, 92, 0, 0, 0, 24, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 16, 0, 0, 0, 2, 0, 0, 0, 233, 253, 0, 0, 24, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 16, 0, 0, 0, 2, 0, 0, 0, 233, 253, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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

  # old code pending "max_dir_entries" do
  # old code   it "doc" do
  # old code     ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
  # old code     ole.max_dir_entries.should eq 8
  # old code   end
  # old code
  # old code   it "excel" do
  # old code     ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
  # old code     ole.max_dir_entries.should eq 8
  # old code   end
  # old code end
end

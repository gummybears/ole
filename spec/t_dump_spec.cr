#
# t_dump_spec.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

require "./spec_helper"

describe "Ole::FileIO" do

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

  describe "dump_directories" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.dump_directories
      ole.status.should eq 0
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ole.dump_directories
      ole.status.should eq 0
    end
  end

  describe "dump_fat" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.dump_fat
      ole.status.should eq 0
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ole.dump_fat
      ole.status.should eq 0
    end
  end

  # old code describe "dump_difat" do
  # old code   it "doc" do
  # old code     ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
  # old code     ole.dump_difat
  # old code     ole.status.should eq 0
  # old code   end
  # old code
  # old code   it "excel" do
  # old code     ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
  # old code     ole.dump_difat
  # old code     ole.status.should eq 0
  # old code   end
  # old code end

  describe "dump_minifat" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.dump_minifat
      ole.status.should eq 0
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ole.dump_minifat
      ole.status.should eq 0
    end
  end

  describe "dump_ministreams" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.dump_ministreams
      ole.status.should eq 0
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ole.dump_ministreams
      ole.status.should eq 0
    end
  end

  describe "dump_sector(sector : UInt32)" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      x = ole.dump_sector(0)
      x.should eq Bytes[253, 255, 255, 255, 255, 255, 255, 255, 254, 255, 255, 255, 112, 0, 0, 0, 5, 0, 0, 0, 6, 0, 0, 0, 7, 0, 0, 0, 8, 0, 0, 0, 9, 0, 0, 0, 10, 0, 0, 0, 11, 0, 0, 0, 12, 0, 0, 0, 13, 0, 0, 0, 14, 0, 0, 0, 15, 0, 0, 0, 16, 0, 0, 0, 17, 0, 0, 0, 18, 0, 0, 0, 19, 0, 0, 0, 20, 0, 0, 0, 21, 0, 0, 0, 22, 0, 0, 0, 23, 0, 0, 0, 24, 0, 0, 0, 25, 0, 0, 0, 26, 0, 0, 0, 27, 0, 0, 0, 28, 0, 0, 0, 29, 0, 0, 0, 30, 0, 0, 0, 31, 0, 0, 0, 32, 0, 0, 0, 33, 0, 0, 0, 34, 0, 0, 0, 35, 0, 0, 0, 36, 0, 0, 0, 37, 0, 0, 0, 38, 0, 0, 0, 39, 0, 0, 0, 40, 0, 0, 0, 41, 0, 0, 0, 42, 0, 0, 0, 43, 0, 0, 0, 44, 0, 0, 0, 45, 0, 0, 0, 46, 0, 0, 0, 47, 0, 0, 0, 48, 0, 0, 0, 49, 0, 0, 0, 50, 0, 0, 0, 51, 0, 0, 0, 52, 0, 0, 0, 53, 0, 0, 0, 54, 0, 0, 0, 55, 0, 0, 0, 56, 0, 0, 0, 57, 0, 0, 0, 58, 0, 0, 0, 59, 0, 0, 0, 60, 0, 0, 0, 61, 0, 0, 0, 62, 0, 0, 0, 63, 0, 0, 0, 64, 0, 0, 0, 65, 0, 0, 0, 66, 0, 0, 0, 67, 0, 0, 0, 68, 0, 0, 0, 69, 0, 0, 0, 70, 0, 0, 0, 71, 0, 0, 0, 72, 0, 0, 0, 73, 0, 0, 0, 74, 0, 0, 0, 75, 0, 0, 0, 76, 0, 0, 0, 77, 0, 0, 0, 78, 0, 0, 0, 79, 0, 0, 0, 80, 0, 0, 0, 81, 0, 0, 0, 82, 0, 0, 0, 83, 0, 0, 0, 84, 0, 0, 0, 85, 0, 0, 0, 86, 0, 0, 0, 87, 0, 0, 0, 88, 0, 0, 0, 89, 0, 0, 0, 90, 0, 0, 0, 91, 0, 0, 0, 92, 0, 0, 0, 93, 0, 0, 0, 94, 0, 0, 0, 95, 0, 0, 0, 96, 0, 0, 0, 97, 0, 0, 0, 98, 0, 0, 0, 99, 0, 0, 0, 100, 0, 0, 0, 101, 0, 0, 0, 102, 0, 0, 0, 103, 0, 0, 0, 104, 0, 0, 0, 105, 0, 0, 0, 106, 0, 0, 0, 107, 0, 0, 0, 108, 0, 0, 0, 109, 0, 0, 0, 110, 0, 0, 0, 111, 0, 0, 0, 254, 255, 255, 255, 113, 0, 0, 0, 114, 0, 0, 0, 115, 0, 0, 0, 116, 0, 0, 0, 254, 255, 255, 255, 118, 0, 0, 0, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255]
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      x = ole.dump_sector(0)
      x.should eq Bytes[253, 255, 255, 255, 255, 255, 255, 255, 254, 255, 255, 255, 4, 0, 0, 0, 5, 0, 0, 0, 6, 0, 0, 0, 7, 0, 0, 0, 254, 255, 255, 255, 9, 0, 0, 0, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255]
      x = ole.dump_sector(3)
      x.should eq Bytes[9, 8, 16, 0, 0, 6, 5, 0, 187, 13, 204, 7, 0, 0, 0, 0, 6, 0, 0, 0, 225, 0, 2, 0, 176, 4, 193, 0, 2, 0, 0, 0, 226, 0, 0, 0, 92, 0, 112, 0, 4, 0, 0, 67, 97, 108, 99, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 66, 0, 2, 0, 176, 4, 97, 1, 2, 0, 0, 0, 192, 1, 0, 0, 61, 1, 2, 0, 1, 0, 156, 0, 2, 0, 14, 0, 175, 1, 2, 0, 0, 0, 188, 1, 2, 0, 0, 0, 61, 0, 18, 0, 0, 0, 0, 0, 0, 64, 0, 32, 56, 0, 0, 0, 0, 0, 1, 0, 244, 1, 64, 0, 2, 0, 0, 0, 141, 0, 2, 0, 0, 0, 34, 0, 2, 0, 0, 0, 14, 0, 2, 0, 1, 0, 183, 1, 2, 0, 0, 0, 218, 0, 2, 0, 0, 0, 49, 0, 26, 0, 200, 0, 0, 0, 255, 127, 144, 1, 0, 0, 0, 2, 0, 0, 5, 1, 65, 0, 114, 0, 105, 0, 97, 0, 108, 0, 49, 0, 26, 0, 200, 0, 0, 0, 255, 127, 144, 1, 0, 0, 0, 0, 0, 0, 5, 1, 65, 0, 114, 0, 105, 0, 97, 0, 108, 0, 49, 0, 26, 0, 200, 0, 0, 0, 255, 127, 144, 1, 0, 0, 0, 0, 0, 0, 5, 1, 65, 0, 114, 0, 105, 0, 97, 0, 108, 0, 49, 0, 26, 0, 200, 0, 0, 0, 255, 127, 144, 1, 0, 0, 0, 0, 0, 0, 5, 1, 65, 0, 114, 0, 105, 0, 97, 0, 108, 0, 30, 4, 12, 0, 164, 0, 7, 0, 0, 71, 101, 110, 101, 114, 97, 108, 224, 0, 20, 0, 0, 0, 164, 0, 245, 255, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 32, 224, 0, 20, 0, 1, 0, 0, 0, 245, 255, 32, 0, 0, 244, 0, 0, 0, 0, 0, 0, 0, 0, 192, 32, 224, 0, 20, 0, 1, 0, 0, 0, 245, 255, 32, 0, 0, 244, 0, 0, 0, 0, 0, 0, 0, 0, 192, 32, 224, 0, 20, 0, 2, 0, 0, 0, 245, 255, 32, 0, 0, 244, 0, 0, 0, 0, 0, 0, 0, 0, 192, 32, 224, 0, 20, 0, 2, 0, 0, 0, 245, 255, 32, 0, 0, 244, 0, 0, 0, 0, 0, 0, 0, 0, 192, 32, 224, 0, 20, 0, 0, 0]
    end
  end

  describe "dump_header" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.status.should eq 0
      ole.dump_header
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ole.status.should eq 0
      ole.dump_header
    end
  end

  describe "dump_file" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      ole.dump_file
      ole.status.should eq 0
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      ole.dump_file
      ole.status.should eq 0
    end

    it "test.ole" do
      ole = Ole::FileIO.new("./spec/ole/test.ole","rb")
      ole.dump_file
      ole.status.should eq 0
    end

  end
end

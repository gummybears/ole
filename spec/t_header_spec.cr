#
# t_header_spec.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
require "./spec_helper"
require "../src/ole.cr"

describe "Ole:Header" do

  #
  # testing just the raw data, no byte order assumed (little or big endian)
  #
  it "get_header" do
    ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
    ole.size.should eq 61440
    ole.status.should eq 0

    header = ole.get_header()
    header.size.should eq 512
  end

  describe "magic" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.magic.should eq "e11ab1a1e011cfd0"
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.magic.should eq "e11ab1a1e011cfd0"
    end
  end

  describe "clsid" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.clsid.should eq "0000000000000000"
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.clsid.should eq "0000000000000000"
    end
  end

  describe "minor_version" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.minor_version.should eq 59
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.minor_version.should eq 59
    end
  end

  describe "major_version" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.major_version.should eq 3
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.major_version.should eq 3
    end
  end

  describe "sector_shift" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.sector_shift.should eq 9
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.sector_shift.should eq 9
    end
  end

  describe "mini_sector_shift" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.mini_sector_shift.should eq 6
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.mini_sector_shift.should eq 6
    end
  end

  describe "reserved" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.reserved.should eq "000000"
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.reserved.should eq "000000"
    end
  end

  describe "nr_dir_sectors" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.nr_dir_sectors.should eq 0
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.nr_dir_sectors.should eq 0
    end
  end

  describe "nr_fat_sectors" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.nr_fat_sectors.should eq 1
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.nr_fat_sectors.should eq 1
    end
  end

  describe "first_dir_sector" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.first_dir_sector.should eq 117
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.first_dir_sector.should eq 8
    end
  end

  describe "trans_sig_number" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.trans_sig_number.should eq 0
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.trans_sig_number.should eq 0
    end
  end

  describe "mini_stream_cutoff" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.mini_stream_cutoff.should eq 4096
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.mini_stream_cutoff.should eq 4096
    end
  end

  describe "first_mini_fat_loc" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.first_mini_fat_loc.should eq 2
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.first_mini_fat_loc.should eq 2
    end
  end

  describe "nr_mini_fat_sectors" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.nr_mini_fat_sectors.should eq 1
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.nr_mini_fat_sectors.should eq 1
    end
  end

  describe "first_difat_loc" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.first_difat_loc.should eq 4294967294
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.first_difat_loc.should eq 4294967294
    end
  end

  describe "nr_dfat_sectors" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.nr_dfat_sectors.should eq 0
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.nr_dfat_sectors.should eq 0
    end
  end

  describe "size" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.size.should eq 512
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.size.should eq 512
    end
  end

  describe "version" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.version.should eq 3
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.version.should eq 3
    end
  end

  describe "sector_size" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.sector_size.should eq 512
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.sector_size.should eq 512
    end
  end

  describe "mini_sector_size (computed)" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.mini_sector_size().should eq 12
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.mini_sector_size().should eq 12
    end
  end

  describe "validate" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.validate.should eq true
      header.errors.size.should eq 0
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.validate.should eq true
      header.errors.size.should eq 0
    end
  end
end


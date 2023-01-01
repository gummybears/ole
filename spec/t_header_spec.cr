#
# t_header_spec.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
require "./spec_helper"
require "../src/ole.cr"

    # # this should be set to 0x3e00
    # ::Ole.to_hex(header.byte_order).should           eq "0xfeff"
    # ::Ole.to_hex(header.sector_shift).should         eq "0x90"
    # ::Ole.to_hex(header.mini_sector_shift).should    eq "0x60"
    # ::Ole.to_hex(header.reserved).should             eq "0x000000"
    # ::Ole.to_hex(header.nr_dir_sectors).should       eq "0x0000"
    # ::Ole.to_hex(header.nr_fat_sectors).should       eq "0x1000"
    # ::Ole.to_hex(header.first_dir_sector_loc).should eq "0x75000"
    # ::Ole.to_hex(header.trans_sig_number).should     eq "0x0000"
    # ::Ole.to_hex(header.mini_stream_cutoff).should   eq "0x01000"
    # ::Ole.to_hex(header.first_mini_fat_loc).should   eq "0x2000"
    # ::Ole.to_hex(header.nr_mini_fat_sectors).should  eq "0x1000"
    # ::Ole.to_hex(header.first_difat_loc).should      eq "0xfeffffff"
    # ::Ole.to_hex(header.nr_dfat_sectors).should      eq "0x0000"
    # ::Ole.to_hex(header.dfat).should                 eq "0x0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"



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
      header.nr_dir_sectors.should eq 1
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.nr_dir_sectors.should eq 1
    end
  end

  describe "nr_fat_sectors()" do
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

  describe "first_dir_sector_loc" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.first_dir_sector_loc.should eq 0x75
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.first_dir_sector_loc.should eq 0x75
    end
  end

  describe "trans_sig_number" do
    it "doc" do
      ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
      header = ole.get_header()
      header.trans_sig_number.should eq 0x75
    end

    it "excel" do
      ole = Ole::FileIO.new("./spec/excel/test.xls","rb")
      header = ole.get_header()
      header.trans_sig_number.should eq 0x75
    end
  end


    # ::Ole.to_hex(header.trans_sig_number).should     eq "0x0000"
    # ::Ole.to_hex(header.mini_stream_cutoff).should   eq "0x01000"
    # ::Ole.to_hex(header.first_mini_fat_loc).should   eq "0x2000"
    # ::Ole.to_hex(header.nr_mini_fat_sectors).should  eq "0x1000"
    # ::Ole.to_hex(header.first_difat_loc).should      eq "0xfeffffff"
    # ::Ole.to_hex(header.nr_dfat_sectors).should      eq "0x0000"




  it "size" do
    ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
    header = ole.get_header()
    header.size.should eq 512
  end

  it "version" do
    ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
    header = ole.get_header()
    header.version.should eq 3
  end

  it "sector_size" do
    ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
    header = ole.get_header()
    header.sector_size.should eq 512
  end

  it "validate" do
    ole = Ole::FileIO.new("./spec/docs/test_word_6.doc","rb")
    header = ole.get_header()
    header.validate.should eq true
    header.errors.size.should eq 0
  end

end


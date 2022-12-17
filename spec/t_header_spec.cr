require "./spec_helper"
require "../src/ole.cr"

def ole_storage(filename : String, mode : String)

end

describe "Ole::Storage|Header" do

  #
  # testing just the raw data, no byte order assumed (little or big endian)
  #
  it "get_header" do
    ole = Ole::Storage.new("./spec/test_word_6.doc","rb")
    ole.size.should eq 61440
    ole.status.should eq 0

    header = ole.get_header()
    to_hex(header.magic).should eq "0xd0cf11e0a1b11ae1"

    # Reserved and unused class ID that MUST be set to all zeroes (CLSID_NULL)
    to_hex(header.clsid).should eq "0x0000000000000000"

    # this should be set to 0x3e00
    to_hex(header.minor_version).should        eq "0x3b0"
    to_hex(header.major_version).should        eq "0x30"
    to_hex(header.byte_order).should           eq "0xfeff"
    to_hex(header.sector_shift).should         eq "0x90"
    to_hex(header.mini_sector_shift).should    eq "0x60"
    to_hex(header.reserved).should             eq "0x000000"
    to_hex(header.nr_dir_sectors).should       eq "0x0000"
    to_hex(header.nr_fat_sectors).should       eq "0x1000"
    to_hex(header.first_dir_sector_loc).should eq "0x75000"
    to_hex(header.trans_sig_number).should     eq "0x0000"
    to_hex(header.mini_stream_cutoff).should   eq "0x01000"
    to_hex(header.first_mini_fat_loc).should   eq "0x2000"
    to_hex(header.nr_mini_fat_sectors).should  eq "0x1000"
    to_hex(header.first_difat_loc).should      eq "0xfeffffff"
    to_hex(header.nr_dfat_sectors).should      eq "0x0000"
    to_hex(header.dfat).should                 eq "0x0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"

  end

  it "size" do
    ole = Ole::Storage.new("./spec/test_word_6.doc","rb")
    header = ole.get_header()
    header.size.should eq 512
  end

  it "version" do
    ole = Ole::Storage.new("./spec/test_word_6.doc","rb")
    header = ole.get_header()
    header.version.should eq 3
  end

  it "sector_size" do
    ole = Ole::Storage.new("./spec/test_word_6.doc","rb")
    header = ole.get_header()
    header.sector_size.should eq 512
  end

  it "validate" do
    ole = Ole::Storage.new("./spec/test_word_6.doc","rb")
    header = ole.get_header()
    header.validate.should eq true
  end

end


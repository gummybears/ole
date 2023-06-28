#
# t_header2_spec.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

require "./spec_helper"
require "../src/header2.cr"

describe "Ole::Header2" do

  describe "determine byte order" do
    it "doc" do
      blob   = Ole::Blob.new("./spec/docs/test.doc","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.byte_order.should eq Ole::ByteOrder::LittleEndian
    end

    it "excel" do
      blob = Ole::Blob.new("./spec/excel/test.xls","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.byte_order.should eq Ole::ByteOrder::LittleEndian
    end

    it "test.ole" do
      blob = Ole::Blob.new("./spec/ole/test.ole","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.byte_order.should eq Ole::ByteOrder::LittleEndian
    end
  end

  describe "size" do
    it "doc" do
      blob   = Ole::Blob.new("./spec/docs/test.doc","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.size.should eq Ole::HEADER_SIZE
    end

    it "excel" do
      blob   = Ole::Blob.new("./spec/excel/test.xls","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.size.should eq Ole::HEADER_SIZE
    end
  end

  describe "magic" do
    it "doc" do
      blob   = Ole::Blob.new("./spec/docs/test.doc","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.magic.should eq "e11ab1a1e011cfd0"
    end

    it "excel" do
      blob   = Ole::Blob.new("./spec/excel/test.xls","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.magic.should eq "e11ab1a1e011cfd0"
    end

    it "test.ole" do
      blob   = Ole::Blob.new("./spec/ole/test.ole","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.magic.should eq "e11ab1a1e011cfd0"
    end
  end

  describe "clsid" do
    it "doc" do
      blob = Ole::Blob.new("./spec/docs/test.doc","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.clsid.should eq "0000000000000000"
    end

    it "excel" do
      blob = Ole::Blob.new("./spec/excel/test.xls","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.clsid.should eq "0000000000000000"
    end

    it "test.ole" do
      blob = Ole::Blob.new("./spec/ole/test.ole","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.clsid.should eq "0000000000000000"
    end
  end

  describe "minor_version" do
    it "doc" do
      blob = Ole::Blob.new("./spec/docs/test.doc","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.minor_version.should eq 59
    end

    it "excel" do
      blob = Ole::Blob.new("./spec/excel/test.xls","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.minor_version.should eq 59
    end

    it "test.ole" do
      blob = Ole::Blob.new("./spec/ole/test.ole","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.minor_version.should eq 62
    end
  end

  describe "major_version" do
    it "doc" do
      blob = Ole::Blob.new("./spec/docs/test.doc","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.major_version.should eq 3
    end

    it "excel" do
      blob = Ole::Blob.new("./spec/excel/test.xls","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.major_version.should eq 3
    end

    it "test.ole" do
      blob = Ole::Blob.new("./spec/ole/test.ole","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.major_version.should eq 3
    end
  end

  describe "sector_shift" do
    it "doc" do
      blob = Ole::Blob.new("./spec/docs/test.doc","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.sector_shift.should eq 9
    end

    it "excel" do
      blob = Ole::Blob.new("./spec/excel/test.xls","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.sector_shift.should eq 9
    end

    it "test.ole" do
      blob = Ole::Blob.new("./spec/ole/test.ole","rb")
      blob.status.should eq 0
      header = Ole::Header2.new(blob)
      header.sector_shift.should eq 9
    end
  end
  #
  #describe "mini_sector_shift" do
  #  it "doc" do
  #    blob = Ole::Blob.new("./spec/docs/test.doc","rb")
  #    header = blob.get_header()
  #    header.mini_sector_shift.should eq 6
  #  end
  #
  #  it "excel" do
  #    blob = Ole::Blob.new("./spec/excel/test.xls","rb")
  #    header = blob.get_header()
  #    header.mini_sector_shift.should eq 6
  #  end
  #
  #  it "test.ole" do
  #    blob = Ole::Blob.new("./spec/ole/test.ole","rb")
  #    header = blob.get_header()
  #    header.mini_sector_shift.should eq 6
  #  end
  #end
  #
  #describe "reserved" do
  #  it "doc" do
  #    blob = Ole::Blob.new("./spec/docs/test.doc","rb")
  #    header = blob.get_header()
  #    header.reserved.should eq "000000"
  #  end
  #
  #  it "excel" do
  #    blob = Ole::Blob.new("./spec/excel/test.xls","rb")
  #    header = blob.get_header()
  #    header.reserved.should eq "000000"
  #  end
  #
  #  it "test.ole" do
  #    blob = Ole::Blob.new("./spec/ole/test.ole","rb")
  #    header = blob.get_header()
  #    header.reserved.should eq "000000"
  #  end
  #end
  #
  #describe "nr_dir_sectors" do
  #  it "doc" do
  #    blob = Ole::Blob.new("./spec/docs/test.doc","rb")
  #    header = blob.get_header()
  #    header.nr_dir_sectors.should eq 0
  #  end
  #
  #  it "excel" do
  #    blob = Ole::Blob.new("./spec/excel/test.xls","rb")
  #    header = blob.get_header()
  #    header.nr_dir_sectors.should eq 0
  #  end
  #
  #  it "test.ole" do
  #    blob = Ole::Blob.new("./spec/ole/test.ole","rb")
  #    header = blob.get_header()
  #    header.nr_dir_sectors.should eq 0
  #  end
  #end
  #
  #describe "nr_fat_sectors" do
  #  it "doc" do
  #    blob = Ole::Blob.new("./spec/docs/test.doc","rb")
  #    header = blob.get_header()
  #    header.nr_fat_sectors.should eq 1
  #  end
  #
  #  it "excel" do
  #    blob = Ole::Blob.new("./spec/excel/test.xls","rb")
  #    header = blob.get_header()
  #    header.nr_fat_sectors.should eq 1
  #  end
  #
  #  it "test.ole" do
  #    blob = Ole::Blob.new("./spec/ole/test.ole","rb")
  #    header = blob.get_header()
  #    header.nr_fat_sectors.should eq 1
  #  end
  #end
  #
  #describe "first_dir_sector" do
  #  it "doc" do
  #    blob = Ole::Blob.new("./spec/docs/test.doc","rb")
  #    header = blob.get_header()
  #    header.first_dir_sector.should eq 117
  #  end
  #
  #  it "excel" do
  #    blob = Ole::Blob.new("./spec/excel/test.xls","rb")
  #    header = blob.get_header()
  #    header.first_dir_sector.should eq 8
  #  end
  #
  #  it "test.ole" do
  #    blob = Ole::Blob.new("./spec/ole/test.ole","rb")
  #    header = blob.get_header()
  #    header.first_dir_sector.should eq 1
  #  end
  #end
  #
  #describe "trans_sig_number" do
  #  it "doc" do
  #    blob = Ole::Blob.new("./spec/docs/test.doc","rb")
  #    header = blob.get_header()
  #    header.trans_sig_number.should eq 0
  #  end
  #
  #  it "excel" do
  #    blob = Ole::Blob.new("./spec/excel/test.xls","rb")
  #    header = blob.get_header()
  #    header.trans_sig_number.should eq 0
  #  end
  #
  #  it "test.ole" do
  #    blob = Ole::Blob.new("./spec/ole/test.ole","rb")
  #    header = blob.get_header()
  #    header.trans_sig_number.should eq 0
  #  end
  #end
  #
  #describe "mini_stream_cutoff" do
  #  it "doc" do
  #    blob = Ole::Blob.new("./spec/docs/test.doc","rb")
  #    header = blob.get_header()
  #    header.mini_stream_cutoff.should eq 4096
  #  end
  #
  #  it "excel" do
  #    blob = Ole::Blob.new("./spec/excel/test.xls","rb")
  #    header = blob.get_header()
  #    header.mini_stream_cutoff.should eq 4096
  #  end
  #
  #  it "test.ole" do
  #    blob = Ole::Blob.new("./spec/ole/test.ole","rb")
  #    header = blob.get_header()
  #    header.mini_stream_cutoff.should eq 4096
  #  end
  #end
  #
  #describe "first_minifat_sector" do
  #  it "doc" do
  #    blob = Ole::Blob.new("./spec/docs/test.doc","rb")
  #    header = blob.get_header()
  #    header.first_minifat_sector.should eq 2
  #  end
  #
  #  it "excel" do
  #    blob = Ole::Blob.new("./spec/excel/test.xls","rb")
  #    header = blob.get_header()
  #    header.first_minifat_sector.should eq 2
  #  end
  #
  #  it "test.ole" do
  #    blob = Ole::Blob.new("./spec/ole/test.ole","rb")
  #    header = blob.get_header()
  #    header.first_minifat_sector.should eq 2
  #  end
  #end
  #
  #describe "nr_mini_fat_sectors" do
  #  it "doc" do
  #    blob = Ole::Blob.new("./spec/docs/test.doc","rb")
  #    header = blob.get_header()
  #    header.nr_mini_fat_sectors.should eq 1
  #  end
  #
  #  it "excel" do
  #    blob = Ole::Blob.new("./spec/excel/test.xls","rb")
  #    header = blob.get_header()
  #    header.nr_mini_fat_sectors.should eq 1
  #  end
  #
  #  it "test.ole" do
  #    blob = Ole::Blob.new("./spec/ole/test.ole","rb")
  #    header = blob.get_header()
  #    header.nr_mini_fat_sectors.should eq 1
  #  end
  #end
  #
  #describe "first_difat_pos" do
  #  it "doc" do
  #    blob = Ole::Blob.new("./spec/docs/test.doc","rb")
  #    header = blob.get_header()
  #    header.first_difat_pos.should eq 4294967294
  #    header.first_difat_pos.should eq Ole::ENDOFCHAIN
  #  end
  #
  #  it "excel" do
  #    blob = Ole::Blob.new("./spec/excel/test.xls","rb")
  #    header = blob.get_header()
  #    header.first_difat_pos.should eq 4294967294
  #    header.first_difat_pos.should eq Ole::ENDOFCHAIN
  #  end
  #
  #  it "test.ole" do
  #    blob = Ole::Blob.new("./spec/ole/test.ole","rb")
  #    header = blob.get_header()
  #    header.first_difat_pos.should eq 4294967294
  #    header.first_difat_pos.should eq Ole::ENDOFCHAIN
  #  end
  #end
  #
  #describe "nr_dfat_sectors" do
  #  it "doc" do
  #    blob = Ole::Blob.new("./spec/docs/test.doc","rb")
  #    header = blob.get_header()
  #    header.nr_dfat_sectors.should eq 0
  #  end
  #
  #  it "excel" do
  #    blob = Ole::Blob.new("./spec/excel/test.xls","rb")
  #    header = blob.get_header()
  #    header.nr_dfat_sectors.should eq 0
  #  end
  #
  #  it "test.ole" do
  #    blob = Ole::Blob.new("./spec/ole/test.ole","rb")
  #    header = blob.get_header()
  #    header.nr_dfat_sectors.should eq 0
  #  end
  #end
  #
  #describe "size" do
  #  it "doc" do
  #    blob = Ole::Blob.new("./spec/docs/test.doc","rb")
  #    header = blob.get_header()
  #    header.size.should eq 512
  #  end
  #
  #  it "excel" do
  #    blob = Ole::Blob.new("./spec/excel/test.xls","rb")
  #    header = blob.get_header()
  #    header.size.should eq 512
  #  end
  #
  #  it "test.ole" do
  #    blob = Ole::Blob.new("./spec/ole/test.ole","rb")
  #    header = blob.get_header()
  #    header.size.should eq 512
  #  end
  #end
  #
  #describe "version" do
  #  it "doc" do
  #    blob = Ole::Blob.new("./spec/docs/test.doc","rb")
  #    header = blob.get_header()
  #    header.version.should eq 3
  #  end
  #
  #  it "excel" do
  #    blob = Ole::Blob.new("./spec/excel/test.xls","rb")
  #    header = blob.get_header()
  #    header.version.should eq 3
  #  end
  #
  #  it "test.ole" do
  #    blob = Ole::Blob.new("./spec/ole/test.ole","rb")
  #    header = blob.get_header()
  #    header.version.should eq 3
  #  end
  #end
  #
  #describe "sector_size" do
  #  it "doc" do
  #    blob = Ole::Blob.new("./spec/docs/test.doc","rb")
  #    header = blob.get_header()
  #    header.sector_size.should eq 512
  #  end
  #
  #  it "excel" do
  #    blob = Ole::Blob.new("./spec/excel/test.xls","rb")
  #    header = blob.get_header()
  #    header.sector_size.should eq 512
  #  end
  #
  #  it "test.ole" do
  #    blob = Ole::Blob.new("./spec/ole/test.ole","rb")
  #    header = blob.get_header()
  #    header.sector_size.should eq 512
  #  end
  #end
  #
  #describe "minifat_sector_size (computed)" do
  #  it "doc" do
  #    blob = Ole::Blob.new("./spec/docs/test.doc","rb")
  #    header = blob.get_header()
  #    header.minifat_sector_size.should eq 64
  #  end
  #
  #  it "excel" do
  #    blob = Ole::Blob.new("./spec/excel/test.xls","rb")
  #    header = blob.get_header()
  #    header.minifat_sector_size.should eq 64
  #  end
  #
  #  it "test.ole" do
  #    blob = Ole::Blob.new("./spec/ole/test.ole","rb")
  #    header = blob.get_header()
  #    header.minifat_sector_size.should eq 64
  #  end
  #end
  #
  #describe "validate" do
  #  it "doc" do
  #    blob = Ole::Blob.new("./spec/docs/test.doc","rb")
  #    header = blob.get_header()
  #    header.validate.should eq true
  #    header.errors.size.should eq 0
  #  end
  #
  #  it "excel" do
  #    blob = Ole::Blob.new("./spec/excel/test.xls","rb")
  #    header = blob.get_header()
  #    header.validate.should eq true
  #    header.errors.size.should eq 0
  #  end
  #
  #  it "test.ole" do
  #    blob = Ole::Blob.new("./spec/ole/test.ole","rb")
  #    header = blob.get_header()
  #    header.validate.should eq true
  #    header.errors.size.should eq 0
  #  end
  #end

end

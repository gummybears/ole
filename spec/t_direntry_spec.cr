#
# t_direntry_spec.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
require "./spec_helper"

describe "Ole::DirectoryEntry" do

  it "name" do
    sid  = 0u32
    data = direntry()
    direntry = Ole::DirectoryEntry.new(data,Ole::ByteOrder::LittleEndian)
    direntry.name.should eq "\u0000R\u0000o\u0000o\u0000t\u0000 \u0000E\u0000n\u0000t\u0000r\u0000y\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000"
  end

  it "type" do
    sid  = 0u32
    data = direntry()
    direntry = Ole::DirectoryEntry.new(data,Ole::ByteOrder::LittleEndian)
    direntry.type.should eq Ole::Storage::Root.to_i
  end

  it "color" do
    sid  = 0u32
    data = direntry()
    direntry = Ole::DirectoryEntry.new(data,Ole::ByteOrder::LittleEndian)
    direntry.color.should eq Ole::Color::Red.to_i
  end

  it "size_name" do
    sid  = 0u32
    data = direntry()
    direntry = Ole::DirectoryEntry.new(data,Ole::ByteOrder::LittleEndian)
    direntry.size_name.should eq 22
  end

  it "left_sid" do
    sid  = 0u32
    data = direntry()
    direntry = Ole::DirectoryEntry.new(data,Ole::ByteOrder::LittleEndian)
    direntry.left_sid.should eq 4294967295
  end

  it "right_sid" do
    sid  = 0u32
    data = direntry()
    direntry = Ole::DirectoryEntry.new(data,Ole::ByteOrder::LittleEndian)
    direntry.right_sid.should eq 4294967295
  end

  it "child_sid" do
    sid  = 0u32
    data = direntry()
    direntry = Ole::DirectoryEntry.new(data,Ole::ByteOrder::LittleEndian)
    direntry.child_sid.should eq 1
  end

  it "clsid" do
    sid  = 0u32
    data = direntry()
    direntry = Ole::DirectoryEntry.new(data,Ole::ByteOrder::LittleEndian)
    direntry.clsid.should eq "\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000"
  end

  it "user_flags" do
    sid  = 0u32
    data = direntry()
    direntry = Ole::DirectoryEntry.new(data,Ole::ByteOrder::LittleEndian)
    direntry.user_flags.should eq 0
  end

  it "ctime" do
    sid  = 0u32
    data = direntry()
    direntry = Ole::DirectoryEntry.new(data,Ole::ByteOrder::LittleEndian)
    direntry.ctime.should eq 0
  end

  it "mtime" do
    sid  = 0u32
    data = direntry()
    direntry = Ole::DirectoryEntry.new(data,Ole::ByteOrder::LittleEndian)
    direntry.mtime.should eq 0
  end

  it "start_sector" do
    sid  = 0u32
    data = direntry()
    direntry = Ole::DirectoryEntry.new(data,Ole::ByteOrder::LittleEndian)
    direntry.start_sector.should eq 4294967294
  end

  it "size_min" do
    sid  = 0u32
    data = direntry()
    direntry = Ole::DirectoryEntry.new(data,Ole::ByteOrder::LittleEndian)
    direntry.size_min.should eq 0
  end

  it "size_max" do
    sid  = 0u32
    data = direntry()
    direntry = Ole::DirectoryEntry.new(data,Ole::ByteOrder::LittleEndian)
    direntry.size_max.should eq 0
  end

end
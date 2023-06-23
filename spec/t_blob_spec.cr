#
# t_dump_spec.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

require "./spec_helper"

describe "Ole::Blob" do

  describe "new" do
    it "doc" do
      mode     = "rb"
      filename = "./spec/docs/test_word_6.doc"
      blob = Ole::Blob.new(filename,mode)
      data = blob.read(Ole::HEADER_SIZE)
      data.size.should eq Ole::HEADER_SIZE
      blob.pos.should eq Ole::HEADER_SIZE
    end

    it "excel" do
      mode     = "rb"
      filename = "./spec/excel/test.xls"
      blob = Ole::Blob.new(filename,mode)
      data = blob.read(Ole::HEADER_SIZE)
      data.size.should eq Ole::HEADER_SIZE
      blob.pos.should eq Ole::HEADER_SIZE
    end
  end

  describe "read_8bits(byte_order : Ole::ByteOrder)" do
    it "memory" do
      bytes = Bytes[0x01,0x02,0x03]
      blob = Ole::Blob.new(bytes)

      x = blob.read_8bits()
      blob.pos.should eq 1
      x.should eq 0x1

      x = blob.read_8bits()
      blob.pos.should eq 2
      x.should eq 0x2
    end
  end

  describe "read_16bits(byte_order : Ole::ByteOrder)" do
    it "memory" do
      bytes = Bytes[0x00,0xFF,0xFE,0xA]
      blob = Ole::Blob.new(bytes)
      x = blob.read_16bits()
      blob.pos.should eq 2
      x.should eq 0xFF00

      x = blob.read_16bits()
      blob.pos.should eq 4
      x.should eq 0x0AFE
    end
  end

  describe "read_32bits(byte_order : Ole::ByteOrder)" do
    it "memory" do
      bytes = Bytes[0x00,0xFF,0xFE,0xA, 0xFF, 0x01, 0xFE, 0xDE]
      blob = Ole::Blob.new(bytes)
      x = blob.read_32bits()
      blob.pos.should eq 4
      x.should eq 0x0AFEFF00

      x = blob.read_32bits()
      blob.pos.should eq 8
      x.should eq 0xDEFE01FF
    end
  end

  describe "read_64bits(byte_order : Ole::ByteOrder)" do
    it "memory" do
      bytes = Bytes[0x00,0x01,0x02,0x03, 0x04, 0x05, 0x06, 0x07]
      blob = Ole::Blob.new(bytes)
      x = blob.read_64bits()
      blob.pos.should eq 8
      x.should eq 0x0706050403020100
    end
  end

  describe "read_integer(size : Int32, byte_order : Ole::ByteOrder = Ole::ByteOrder::LittleEndian) : UInt64" do
    it "size is 1" do
      bytes = Bytes[0x02,0x01]
      blob = Ole::Blob.new(bytes)
      x = blob.read_integer(1)
      blob.pos.should eq 1
      x.should eq 0x02
    end

    it "size is 2" do
      bytes = Bytes[0x02,0x01]
      blob = Ole::Blob.new(bytes)
      x = blob.read_integer(2)
      blob.pos.should eq 2
      x.should eq 0x0102
    end

    it "size is 4" do
      bytes = Bytes[0x04,0x03,0x02,0x01]
      blob = Ole::Blob.new(bytes)
      x = blob.read_integer(4)
      blob.pos.should eq 4
      x.should eq 0x01020304
    end

    it "size is 8" do
      bytes = Bytes[0x08,0x07,0x06,0x05,0x04,0x03,0x02,0x01]
      blob = Ole::Blob.new(bytes)
      x = blob.read_integer(8)
      blob.pos.should eq 8
      x.should eq 0x0102030405060708
    end

    it "size is 8 followed by size is 2" do
      bytes = Bytes[0x08,0x07,0x06,0x05,0x04,0x03,0x02,0x01,0x10,0x09]
      blob = Ole::Blob.new(bytes)

      x = blob.read_integer(8)
      blob.pos.should eq 8
      x.should eq 0x0102030405060708

      x = blob.read_integer(2)
      blob.pos.should eq 10
      x.should eq 0x0910
    end
  end

  describe "read_string(byte_order : Ole::ByteOrder = Ole::ByteOrder::LittleEndian) : String" do
    it "Data for stream 1" do

      bytes = Bytes[0x44, 0, 0x61, 0,  0x74, 0, 0x61, 0, 0x20, 0, 0x66, 0, 0x6F, 0, 0x72, 0, 0x20, 0, 0x73, 0, 0x74, 0, 0x72, 0, 0x65, 0, 0x61, 0, 0x6D, 0, 0x20, 0, 0x31]

      blob = Ole::Blob.new(bytes)
      x = blob.read_string(bytes.size)

      blob.pos.should eq 33
      x.should eq "Data for stream 1"
    end
  end

  describe "write_8bits(value : Int8)" do
    it "1" do
      blob = Ole::Blob.new(256)

      value = 1.to_i8
      blob.write_8bits(value)
      blob.pos.should eq 1
      blob.rewind()

      x = blob.read_8bits()
      blob.pos.should eq 1
      x.should eq value
    end

    it "255" do
      blob = Ole::Blob.new(256)

      value = 127.to_i8
      blob.write_8bits(value)
      blob.pos.should eq 1
      blob.rewind()

      x = blob.read_8bits()
      blob.pos.should eq 1
      x.should eq value

    end
  end

  describe "write_16bits(value : Int16)" do
    it "1" do
      blob = Ole::Blob.new(256)

      blob.write_16bits(1)
      # 2 bytes
      blob.pos.should eq 2
      blob.rewind()

      # 2 bytes
      x = blob.read_16bits()
      blob.pos.should eq 2
      x.should eq 0x01
    end

    it "2**8-1" do
      blob = Ole::Blob.new(256)

      value = 2**8 - 1
      blob.write_16bits(value.to_i16)
      # 2 bytes
      blob.pos.should eq 2
      blob.rewind()

      # 2 bytes
      x = blob.read_16bits()
      blob.pos.should eq 2
      x.should eq value
    end
  end

  describe "write_32bits(value : Int32)" do
    it "1" do
      blob = Ole::Blob.new(256)

      blob.write_32bits(1)
      # 4 bytes
      blob.pos.should eq 4
      blob.rewind()

      # 4 bytes
      x = blob.read_32bits()
      blob.pos.should eq 4
      x.should eq 0x01
    end

    it "2**16-1" do
      blob = Ole::Blob.new(256)

      value = 2**16 - 1
      blob.write_32bits(value.to_i32)
      # 4 bytes
      blob.pos.should eq 4
      blob.rewind()

      # 4 bytes
      x = blob.read_32bits()
      blob.pos.should eq 4
      x.should eq value
    end
  end

  describe "write_64bits(value : Int64)" do
    it "1" do
      blob = Ole::Blob.new(256)

      blob.write_64bits(1)
      # 8 bytes
      blob.pos.should eq 8
      blob.rewind()

      # 8 bytes
      x = blob.read_64bits()
      blob.pos.should eq 8
      x.should eq 0x01
    end

    it "2**16-1" do
      blob = Ole::Blob.new(1024)

      value = 2**16 - 1
      blob.write_64bits(value.to_i64)
      # 8 bytes
      blob.pos.should eq 8
      blob.rewind()

      # 8 bytes
      x = blob.read_64bits()
      blob.pos.should eq 8
      x.should eq value
    end
  end

  describe "write_string(value : String)" do
    it "Hello" do
      blob = Ole::Blob.new(256)
      blob.write_string("Hello")
      # size of Hello * 2
      blob.pos.should eq 10
      blob.rewind()

      x = blob.read_string(10)
      blob.pos.should eq 10
      x.should eq "Hello"
    end

  end
end

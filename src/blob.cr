#
# blob.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
require "./constants.cr"
require "./header2.cr"

module Ole

  class Blob

    property mode                 : String = ""
    property filename             : String = ""
    property errors               : Array(String) = [] of String
    property status               : Int32 = 0
    property size                 : Int64 = 0
    property io                   : IO
    property pos                  : Int32 = 0

    def initialize(filename : String, mode : String)

      @filename = filename
      @mode     = mode

      if File.exists?(filename) == false
        set_error("file '#{filename}' not found")
        return
      end

      file  = File.new(filename)
      @size = file.size
      #bytes = Bytes.new(@size)
      #@io   = IO::Memory.new(bytes)
      @io  = file
      @io.rewind
    end

    def initialize(bytes : Bytes)
      @size = bytes.size.to_i64
      @io   = IO::Memory.new(bytes)
    end

    def initialize(size : Int64)
      @size = size
      bytes = Bytes.new(size)
      @io   = IO::Memory.new(bytes)
    end

    def initialize
      bytes = Bytes.new(0)
      @io   = IO::Memory.new(bytes)
    end

    def read(size : Int32) : Bytes
      slice = Bytes.new(size)
      @io.read(slice)
      slice
    end

    def pos : Int32
      @io.pos.to_i32
    end

    def read_8bits(byte_order : Ole::ByteOrder = Ole::ByteOrder::LittleEndian) : UInt8
      slice = Bytes.new(1)
      @io.read(slice)
      x = Ole.endian_u8(slice, byte_order)
      return x
    end

    def read_16bits(byte_order : Ole::ByteOrder = Ole::ByteOrder::LittleEndian) : UInt16
      slice = Bytes.new(2)
      @io.read(slice)
      x = Ole.endian_u16(slice, byte_order)
      return x
    end

    def read_32bits(byte_order : Ole::ByteOrder = Ole::ByteOrder::LittleEndian) : UInt32
      slice = Bytes.new(4)
      @io.read(slice)
      x = Ole.endian_u32(slice, byte_order)
      return x
    end

    def read_64bits(byte_order : Ole::ByteOrder = Ole::ByteOrder::LittleEndian) : UInt64
      slice = Bytes.new(8)
      @io.read(slice)
      x = Ole.endian_u64(slice, byte_order)
      return x
    end

    def read_integer(size : Int32, byte_order : Ole::ByteOrder = Ole::ByteOrder::LittleEndian) : UInt64
      x = 0
      case size
        when 1

          return read_8bits(byte_order).to_u64

        when 2

          return read_16bits(byte_order).to_u64

        when 4

          return read_32bits(byte_order).to_u64

        when 8

          return read_64bits(byte_order).to_u64

      end

      return x.to_u64
    end

    def read_string(size : Int32, byte_order : Ole::ByteOrder = Ole::ByteOrder::LittleEndian) : String

      slice = Bytes.new(size)
      len   = slice.size.to_u32 + 2
      @io.read(slice)
      s = Ole::ConvertString.new(slice,len,byte_order).to_s()
      s = String.to_utf8(s.chars)
      return s
    end

    def read_bytes(size : Int32, byte_order : Ole::ByteOrder = Ole::ByteOrder::LittleEndian) : String

      slice = Bytes.new(size)
      len   = slice.size.to_u32
      @io.read(slice)
      s = ""
      slice.each do |x|
        s = s + x.chr
      end
      return s
    end

    def read_bytes(size : Int32) : Bytes
      slice = Bytes.new(size)
      len   = slice.size.to_u32
      @io.read(slice)
      return slice
    end

    def write_8bits(value : Int8, byte_order : Ole::ByteOrder = Ole::ByteOrder::LittleEndian)
      case byte_order
        when Ole::ByteOrder::LittleEndian
          @io.write_bytes(value, IO::ByteFormat::LittleEndian)

        when Ole::ByteOrder::BigEndian
          @io.write_bytes(value, IO::ByteFormat::BigEndian)

      end
    end

    def write_16bits(value : Int16, byte_order : Ole::ByteOrder = Ole::ByteOrder::LittleEndian)
      case byte_order
        when Ole::ByteOrder::LittleEndian
          @io.write_bytes(value, IO::ByteFormat::LittleEndian)

        when Ole::ByteOrder::BigEndian
          @io.write_bytes(value, IO::ByteFormat::BigEndian)

      end
    end

    def write_32bits(value : Int32, byte_order : Ole::ByteOrder = Ole::ByteOrder::LittleEndian)
      case byte_order
        when Ole::ByteOrder::LittleEndian
          @io.write_bytes(value, IO::ByteFormat::LittleEndian)

        when Ole::ByteOrder::BigEndian
          @io.write_bytes(value, IO::ByteFormat::BigEndian)

      end
    end

    def write_64bits(value : Int64, byte_order : Ole::ByteOrder = Ole::ByteOrder::LittleEndian)
      case byte_order
        when Ole::ByteOrder::LittleEndian
          @io.write_bytes(value, IO::ByteFormat::LittleEndian)

        when Ole::ByteOrder::BigEndian
          @io.write_bytes(value, IO::ByteFormat::BigEndian)
      end
    end

    def write_string(value : String, byte_order : Ole::ByteOrder = Ole::ByteOrder::LittleEndian)

      case byte_order
        when Ole::ByteOrder::LittleEndian
          slice = value.encode("UTF-16LE")
          @io.write(slice)

        when Ole::ByteOrder::BigEndian
          slice = value.encode("UTF-16BE")
          @io.write(slice)
      end
    end

    #def read_header() : Header2
    #
    #  # old code slice = Bytes.new(Ole::HEADER_SIZE)
    #  # old code @io.rewind
    #  # old code @io.read(slice)
    #  # old code
    #  # old code header = Header2.new(slice)
    #  # old code return header
    #
    #  # header = Header2.new(self)
    #  # return header
    #end

    def set_error(s : String)
      @errors << "ole error : #{s}"
      @status = -1
    end

    def set_warning(s : String)
      @errors << "ole warning : #{s}"
      @status = -2
    end

    def rewind
      @io.rewind
    end
  end
end

#
# helper.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
module Ole

  def self.to_raw(bytes : Bytes, byte_order : ByteOrder = ByteOrder::None) : String
    s = ""

    case byte_order
      when ByteOrder::None

        bytes.each do |e|
          s = s + sprintf("%0x",e)
        end

      when ByteOrder::LittleEndian

        #
        # be careful using reverse!
        # clone bytes and than reverse!
        #
        x = bytes.clone
        x.reverse!
        x.each do |e|
          s = s + sprintf("%0x",e)
        end

      else

    end

    return s
  end

  def self.to_hex(bytes : Bytes, byte_order : ByteOrder = ByteOrder::None, leading_zero : Bool = false)
    s = "0x"

    case byte_order
      when ByteOrder::None

        bytes.each do |e|
          if leading_zero
            s = s + sprintf("%0.2x",e)
          else
            s = s + sprintf("%0x",e)
          end
        end

      when ByteOrder::LittleEndian

        #
        # be careful using reverse!
        # clone bytes and than reverse!
        #
        x = bytes.clone
        x.reverse!
        x.each do |e|
          if leading_zero
            s = s + sprintf("%0.2x",e)
          else
            s = s + sprintf("%0x",e)
          end
        end

      else

    end

    return s
  end

  def self.endian_u8(bytes : Bytes, byte_order : Ole::ByteOrder)
    x = self.le_u8(bytes)
    if byte_order == Ole::ByteOrder::BigEndian
      x = self.be_u8(bytes)
    end
    x
  end

  def self.endian_u16(bytes : Bytes, byte_order : Ole::ByteOrder)
    x = self.le_u16(bytes)
    if byte_order == Ole::ByteOrder::BigEndian
      x = self.be_u16(bytes)
    end
    x
  end

  def self.endian_u32(bytes : Bytes, byte_order : Ole::ByteOrder)
    x = self.le_u32(bytes)
    if byte_order == Ole::ByteOrder::BigEndian
      x = self.be_u32(bytes)
    end
    x
  end

  def self.endian_u64(bytes : Bytes, byte_order : Ole::ByteOrder)
    x = self.le_u64(bytes)
    if byte_order == Ole::ByteOrder::BigEndian
      x = self.be_u64(bytes)
    end
    x
  end

  def self.le_u8(bytes : Bytes) : UInt8
    IO::ByteFormat::LittleEndian.decode(UInt8, bytes)
  end

  def self.le_u16(bytes : Bytes) : UInt16
    IO::ByteFormat::LittleEndian.decode(UInt16, bytes)
  end

  def self.le_u32(bytes : Bytes) : UInt32
    IO::ByteFormat::LittleEndian.decode(UInt32, bytes)
  end

  def self.le_u64(bytes : Bytes) : UInt64
    IO::ByteFormat::LittleEndian.decode(UInt64, bytes)
  end

  def self.le_string(bytes : Bytes, len : Int32) : String
    Ole::ConvertString.new(bytes,len.to_u32,Ole::ByteOrder::LittleEndian).to_s()
  end

  def self.le_datetime(bytes : Bytes) : Time
    Ole::ConvertDateTime.new(bytes).to_time()
  end

  def self.be_u8(bytes : Bytes) : UInt8
    IO::ByteFormat::BigEndian.decode(UInt8, bytes)
  end

  def self.be_u16(bytes : Bytes) : UInt16
    IO::ByteFormat::BigEndian.decode(UInt16, bytes)
  end

  def self.be_u32(bytes : Bytes) : UInt32
    IO::ByteFormat::BigEndian.decode(UInt32, bytes)
  end

  def self.be_u64(bytes : Bytes) : UInt64
    IO::ByteFormat::BigEndian.decode(UInt64, bytes)
  end
end

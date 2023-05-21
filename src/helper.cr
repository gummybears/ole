#
# helper.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
module Ole

  # old code def self.to_raw(bytes : Bytes, byte_order : ByteOrder = ByteOrder::None, leading_zero : Bool = false) : String
  # old code   # old code s = ""
  # old code   # old code
  # old code   # old code case byte_order
  # old code   # old code   when ByteOrder::None
  # old code   # old code
  # old code   # old code     # old code bytes.each do |e|
  # old code   # old code     # old code   s = s + sprintf("%0x",e)
  # old code   # old code     # old code end
  # old code   # old code
  # old code   # old code     bytes.each do |e|
  # old code   # old code       if leading_zero
  # old code   # old code         s = s + sprintf("%0.2x",e)
  # old code   # old code       else
  # old code   # old code         s = s + sprintf("%0x",e)
  # old code   # old code       end
  # old code   # old code     end
  # old code   # old code
  # old code   # old code   when ByteOrder::LittleEndian
  # old code   # old code
  # old code   # old code     #
  # old code   # old code     # be careful using reverse!
  # old code   # old code     # clone bytes and than reverse!
  # old code   # old code     #
  # old code   # old code     x = bytes.clone
  # old code   # old code     x.reverse!
  # old code   # old code     # old code x.each do |e|
  # old code   # old code     # old code   s = s + sprintf("%0x",e)
  # old code   # old code     # old code end
  # old code   # old code
  # old code   # old code     x.each do |e|
  # old code   # old code       if leading_zero
  # old code   # old code         s = s + sprintf("%0.2x",e)
  # old code   # old code       else
  # old code   # old code         s = s + sprintf("%0x",e)
  # old code   # old code       end
  # old code   # old code     end
  # old code   # old code
  # old code   # old code   else
  # old code   # old code
  # old code   # old code end
  # old code   # old code
  # old code   # old code return s
  # old code
  # old code   ::Ole.to_hex(bytes,byte_order,"",leading_zero)
  # old code end

  def self.to_hex(bytes : Bytes, byte_order : ByteOrder = ByteOrder::None, prefix : String = "0x", leading_zero : Bool = false)
    # old code s = "0x"

    s = prefix

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

  #
  # Little Endian helpers
  #
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

  #
  # Big Endian helpers
  #
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

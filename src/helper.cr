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

  def self.le_utf16(bytes : Bytes, length : UInt32) : String

    arr = bytes[0..length-1]
    puts "arr #{arr} size arr #{arr.size}"
    "xxx"
  end

  # old code def self.little_endian(bytes : Bytes) : (Int16|Int32)
  # old code   r = 0
  # old code   case bytes.size
  # old code     when 2
  # old code       r = IO::ByteFormat::LittleEndian.decode(Int16, bytes)
  # old code     when 4
  # old code       r = IO::ByteFormat::LittleEndian.decode(Int32, bytes)
  # old code   else
  # old code     return 0
  # old code   end
  # old code
  # old code   return r
  # old code end
end

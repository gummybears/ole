#
# helper.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
module Ole

  enum ByteOrder
    None
    LittleEndian
    BigEndian
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

  def self.little_endian(bytes : Bytes) : (Int16|Int32)
    r = 0
    case bytes.size
      when 2
        r = IO::ByteFormat::LittleEndian.decode(Int16, bytes)
      when 4
        r = IO::ByteFormat::LittleEndian.decode(Int32, bytes)
    else
      return 0
    end

    return r
  end

end

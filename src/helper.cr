#
# helper.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

module Ole

  def self.to_hex(bytes : Bytes, leading_zero : Bool = false)
    s = "0x"
    bytes.each do |e|
      if leading_zero
        s = s + sprintf("%0.2x",e)
      else
        s = s + sprintf("%0x",e)
      end
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

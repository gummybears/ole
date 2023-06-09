#
# string.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#

class String
  def self.to_utf8(s_utf16 : Array(Char)) : String

    s = String.build do |io|

      s_utf16.each do |e|
        if e.ord >= 32 && e.ord < 255
          io << e
        end
      end
    end

    return s
  end

  def self.to_utf8(s_utf16 : String) : String

    s = String.build do |io|

      s_utf16.chars.each do |e|
        if e.ord >= 32 && e.ord < 255
          io << e
        end
      end
    end

    return s
  end

end

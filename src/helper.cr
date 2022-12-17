module Ole
  # old code def to_hex(x)
  # old code   s = "0x"
  # old code   x.each do |e|
  # old code     s = s + sprintf("%0.2x",e)
  # old code   end
  # old code
  # old code   return s
  # old code end

  def to_hex(x)
    s = "0x"
    x.each do |e|
      s = s + sprintf("%0x",e)
    end

    return s
  end

end

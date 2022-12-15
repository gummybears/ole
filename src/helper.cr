
module Ole
  def to_hex(x)
    s = "0x"
    x.each do |e|
      s = s + sprintf("%0.2x",e)
    end

    return s
  end
end

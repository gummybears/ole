require "spec"
require "../src/ole.cr"

def to_hex(x)
  s = "0x"
  x.each do |e|
    s = s + sprintf("%0x",e)
  end

  return s
end

def ole_storage(filename : String, mode : String)
  Ole::Storage.new("./spec/test_word_6.doc","rb")
end

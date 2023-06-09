require "../..//src/ole.cr"

filename = "../ole/test.ole"
ole = Ole::FileIO.new(filename,"rb")
puts "ole errors #{ole.errors}"
if ole.status == 0
  ole.dump_file()
end

require "./src/ole.cr"
ole = Ole::FileIO.new("test.ole","rb")
ole.dump_file()

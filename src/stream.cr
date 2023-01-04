#
# stream.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
#
require "./helper.cr"
require "./constants.cr"

#
# OLE2 Stream
#
# Returns a read-only file object which can be used to read
# the contents of a OLE stream (instance of the BytesIO class).
# To open a stream, use the openstream method in the OleFileIO class.
#
# This function can be used with either ordinary streams,
# or ministreams, depending on the offset, sectorsize, and
# fat table arguments.
#

module Ole
  class Stream
    #
    # sector     : sector index of first sector in the stream
    # size       : total size of the stream
    # offset     : offset in bytes for the first FAT or MiniFAT sector
    # sectorsize : size of one sector
    # fat        : array/list of sector indexes (FAT or MiniFAT)
    # filesize   : size of OLE file (for debugging)
    #
    def initialize(bytes : Bytes, sector : UInt32, size : UInt32, offset : UInt32, sector_size : UInt32, fat : Array(UInt32), filesize : UInt32)

        unknown_size = false
        size         = 0u32

        if size == UNKNOWN_SIZE

          #
          # this is the case when size is not known in advance,
          # for example when reading the Directory stream.
          # Then we can only guess maximum size
          #
          size = fat.size * sectorsize
          # and we keep a record that size was unknown:
          unknown_size = true
        end

        max_sectors = ((size + (sectorsize -1))/sectorsize).to_u32

        #
        # This number should (at least) be less than the total number of
        # sectors in the given FAT
        #
        if max_sectors > fat.size
          # self.ole._raise_defect(DEFECT_INCORRECT, 'malformed OLE document, stream too large')
        end

        data = [] of String
        # if size is zero, then first sector index should be ENDOFCHAIN:
        if size == 0 && sect != ENDOFCHAIN
          #print('size == 0 and sect != ENDOFCHAIN:')
          #self.ole._raise_defect(DEFECT_INCORRECT, 'incorrect OLE sector index for empty stream')
        end

        (0..max_sector).each do |i|
          #for i in range(nb_sectors):
          #print('Reading stream sector[%d] = %Xh' % (i, sect))

          # Sector index may be ENDOFCHAIN, but only if size was unknown
          if sect == ENDOFCHAIN
            if unknown_size
                #print('Reached ENDOFCHAIN sector for stream with unknown size')
                break
            else
              # else this means that the stream is smaller than declared:
              # print('sect=ENDOFCHAIN before expected size')
              # self.ole._raise_defect(DEFECT_INCORRECT, 'incomplete OLE stream')
            end
          end

          # sector index should be within FAT:
          if sector < 0 || sector >= fat.size

              # print('sect=%d (%X) / len(fat)=%d' % (sect, sect, len(fat)))
              # print('i=%d / nb_sectors=%d' %(i, nb_sectors))
              #
              # self.ole._raise_defect(DEFECT_INCORRECT, 'incorrect OLE FAT, sector index out of range')
              # stop reading here if the exception is ignored:
              break
          end

          # try:
          #     fp.seek(offset + sectorsize * sect)
          # except Exception:
          #     print('sect=%d, seek=%d, filesize=%d' %
          #         (sect, offset+sectorsize*sect, filesize))
          #     self.ole._raise_defect(DEFECT_INCORRECT, 'OLE sector index out of range')
          #     # stop reading here if the exception is ignored:
          #     break
          # end

          # sector_data = fp.read(sectorsize)

          # check if there was enough data:
          # Note: if sector is the last of the file, sometimes it is not a
          # complete sector (of 512 or 4K), so we may read less than
          # sectorsize.

          # if len(sector_data)!=sectorsize and sect!=(len(fat)-1):
          #     print('sect=%d / len(fat)=%d, seek=%d / filesize=%d, len read=%d' %
          #         (sect, len(fat), offset+sectorsize*sect, filesize, len(sector_data)))
          #     print('seek+len(read)=%d' % (offset+sectorsize*sect+len(sector_data)))
          #     self.ole._raise_defect(DEFECT_INCORRECT, 'incomplete OLE sector')
          # data.append(sector_data)
          # # jump to next sector in the FAT:
          # try:
          #     sect = fat[sect] & 0xFFFFFFFF  # JYTHON-WORKAROUND
          # except IndexError:
          #     # [PL] if pointer is out of the FAT an exception is raised
          #     self.ole._raise_defect(DEFECT_INCORRECT, 'incorrect OLE FAT, sector index out of range')
          #     # stop reading here if the exception is ignored:
          #     break

        end

        # Last sector should be a "end of chain" marker:
        # if sect != ENDOFCHAIN:
        #     raise IOError('incorrect last sector index in OLE stream')

        # data = b"".join(data)
        # # Data is truncated to the actual stream size:
        # if len(data) >= size
        #     print('Read data of length %d, truncated to stream size %d' % (len(data), size))
        #     data = data[:size]
        #     # actual stream size is stored for future use:
        #     self.size = size
        # elsif unknown_size
        #     # actual stream size was not known, now we know the size of read
        #     # data:
        #     print('Read data of length %d, the stream size was unknown' % len(data))
        #     self.size = len(data)
        # else
        #     # read data is less than expected:
        #     print('Read data of length %d, less than expected stream size %d' % (len(data), size))
        #     # TODO: provide details in exception message
        #     self.size = len(data)
        #     self.ole._raise_defect(DEFECT_INCORRECT, 'OLE stream size is less than declared')
        # end
        #
        # # when all data is read in memory, BytesIO constructor is called
        # io.BytesIO.__init__(self, data)


    end

  end
end

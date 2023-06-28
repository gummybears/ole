#
# constants.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
require "./helper.cr"

module Ole

  HEADER_SIZE     = 512
  UNKNOWN_SIZE    = 0x7FFFFFFF

  #
  # Added constants for Sector ID's
  #
  MAXREGSECT      = 0xFFFFFFFA # (-6) maximum sector
  DIFSECT         = 0xFFFFFFFC # (-4) denotes a DIFAT sector in a FAT
  FATSECT         = 0xFFFFFFFD # (-3) denotes a FAT sector in a FAT
  ENDOFCHAIN      = 0xFFFFFFFE # (-2) end of a chain
  FREESECT        = 0xFFFFFFFF # (-1) free sector

  S_HEADER        = "Header"
  S_FREESECTOR    = "Free sector"
  S_ENDOFCHAIN    = "End of chain"
  S_FATSECTOR     = "Fat sector"
  S_MINIFATSECTOR = "Mini Fat sector"
  S_DIRECTORY     = "Directory sector"

  S_ROOT          = "Root"
  S_STREAM        = "Stream"
  S_FAT           = "FAT"
  S_MINIFAT       = "Mini FAT"
  S_STORAGE       = "Storage"
  S_LOCKBYTES     = "LockBytes"
  S_EMPTY         = "Empty"
  S_NONE          = "None"
  S_PROPERTY      = "Property"
  S_UNKNOWN       = "Unknown"
  S_INVALID       = "Invalid"

  #
  # Added constants for Directory Entry ID's
  #
  MAXREGSID       = 0xFFFFFFFA # (-6) maximum directory entry ID
  NOSTREAM        = 0xFFFFFFFF # (-1) unallocated directory entry

  #
  # Object types in storage
  #
  enum Storage
    Empty     = 0 # empty directory entry
    Storage   = 1 # element is a storage object
    Stream    = 2 # element is a stream object
    Lockbytes = 3 # element is an ILockBytes object
    Property  = 4 # element is an IPropertyStorage object
    Root      = 5 # element is a root storage
  end

  enum ByteOrder
    None
    LittleEndian
    BigEndian
  end

  enum Color
    Red
    Black
  end

  TEN_MILLION = 10_000_000
  YEAR_1601   = 1601
  FOUR_K      = 4 * 1024
  ONE_K       = 1024
  EIGHT_K     = 128
end

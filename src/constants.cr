#
# constants.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
require "./helper.cr"

module Ole

  UNKNOWN_SIZE    = 0x7FFFFFFF

  #
  # Added constants for Sector ID's
  #
  MAXREGSECT      = 0xFFFFFFFA # (-6) maximum sector
  DIFSECT         = 0xFFFFFFFC # (-4) denotes a DIFAT sector in a FAT
  FATSECT         = 0xFFFFFFFD # (-3) denotes a FAT sector in a FAT
  ENDOFCHAIN      = 0xFFFFFFFE # (-2) end of a virtual stream chain
  FREESECT        = 0xFFFFFFFF # (-1) unallocated sector

  S_HEADER        = "Header"
  S_FREESECTOR    = "Free sector"
  S_ENDOFCHAIN    = "End of chain"
  S_FATSECTOR     = "Fat sector"
  S_MINIFATSECTOR = "Mini Fat sector"
  S_DIRECTORY     = "Directory"

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

  # old code #
  # old code # Property types
  # old code # see https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-oleps/2a4589eb-9a23-4a8b-adbd-3e368233c099
  # old code #
  # old code VT_EMPTY           = 0
  # old code VT_NULL            = 1
  # old code VT_I2              = 2
  # old code VT_I4              = 3
  # old code VT_R4              = 4
  # old code VT_R8              = 5
  # old code VT_CY              = 6
  # old code VT_DATE            = 7
  # old code VT_BSTR            = 8
  # old code VT_DISPATCH        = 9
  # old code VT_ERROR           = 10
  # old code VT_BOOL            = 11
  # old code VT_VARIANT         = 12
  # old code VT_UNKNOWN         = 13
  # old code VT_DECIMAL         = 14
  # old code VT_I1              = 16
  # old code VT_UI1             = 17
  # old code VT_UI2             = 18
  # old code VT_UI4             = 19
  # old code VT_I8              = 20
  # old code VT_UI8             = 21
  # old code VT_INT             = 22
  # old code VT_UINT            = 23
  # old code VT_VOID            = 24
  # old code VT_HRESULT         = 25
  # old code VT_PTR             = 26
  # old code VT_SAFEARRAY       = 27
  # old code VT_CARRAY          = 28
  # old code VT_USERDEFINED     = 29
  # old code VT_LPSTR           = 30
  # old code VT_LPWSTR          = 31
  # old code VT_FILETIME        = 64
  # old code VT_BLOB            = 65
  # old code VT_STREAM          = 66
  # old code VT_STORAGE         = 67
  # old code VT_STREAMED_OBJECT = 68
  # old code VT_STORED_OBJECT   = 69
  # old code VT_BLOB_OBJECT     = 70
  # old code VT_CF              = 71
  # old code VT_CLSID           = 72
  # old code VT_VECTOR          = 0x1000

  # old code#
  # old code# Defect levels to classify parsing errors
  # old code#
  # old codeDEFECT_UNSURE =    10 # a case which looks weird, but not sure it's a defect
  # old codeDEFECT_POTENTIAL = 20 # a potential defect
  # old codeDEFECT_INCORRECT = 30 # an error according to specifications, but parsing
  # old code                      # can go on
  # old codeDEFECT_FATAL =     40 # an error which cannot be ignored, parsing is
  # old code                      # impossible

  #
  # Minimal size of an empty OLE file, with 512-bytes sectors = 1536 bytes
  #
  MINIMAL_OLEFILE_SIZE = 1536

  TEN_MILLION = 10_000_000
  YEAR_1601   = 1601
end

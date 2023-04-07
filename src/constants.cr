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

  #
  # Property types
  # see https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-oleps/2a4589eb-9a23-4a8b-adbd-3e368233c099
  #
  VT_EMPTY           = 0
  VT_NULL            = 1
  VT_I2              = 2
  VT_I4              = 3
  VT_R4              = 4
  VT_R8              = 5
  VT_CY              = 6
  VT_DATE            = 7
  VT_BSTR            = 8
  VT_DISPATCH        = 9
  VT_ERROR           = 10
  VT_BOOL            = 11
  VT_VARIANT         = 12
  VT_UNKNOWN         = 13
  VT_DECIMAL         = 14
  VT_I1              = 16
  VT_UI1             = 17
  VT_UI2             = 18
  VT_UI4             = 19
  VT_I8              = 20
  VT_UI8             = 21
  VT_INT             = 22
  VT_UINT            = 23
  VT_VOID            = 24
  VT_HRESULT         = 25
  VT_PTR             = 26
  VT_SAFEARRAY       = 27
  VT_CARRAY          = 28
  VT_USERDEFINED     = 29
  VT_LPSTR           = 30
  VT_LPWSTR          = 31
  VT_FILETIME        = 64
  VT_BLOB            = 65
  VT_STREAM          = 66
  VT_STORAGE         = 67
  VT_STREAMED_OBJECT = 68
  VT_STORED_OBJECT   = 69
  VT_BLOB_OBJECT     = 70
  VT_CF              = 71
  VT_CLSID           = 72
  VT_VECTOR          = 0x1000

  #
  # Defect levels to classify parsing errors
  #
  DEFECT_UNSURE =    10 # a case which looks weird, but not sure it's a defect
  DEFECT_POTENTIAL = 20 # a potential defect
  DEFECT_INCORRECT = 30 # an error according to specifications, but parsing
                        # can go on
  DEFECT_FATAL =     40 # an error which cannot be ignored, parsing is
                        # impossible

  #
  # Minimal size of an empty OLE file, with 512-bytes sectors = 1536 bytes
  #
  MINIMAL_OLEFILE_SIZE = 1536

  TEN_MILLION = 10_000_000
  YEAR_1601   = 1601
end

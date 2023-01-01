#
# metadata.cr
#
# author : W.F.F. Neimeijer
# copyright 2007-2023, ICUBIC
#
require "./helper.cr"
require "./constants.cr"

#
# see https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-oleps/df2e0abe-365f-4bf8-a630-6c1f560238c8
#

module Ole

  alias None = (Int32|Int64|Float32|Float64|String|Time)

  class MetaData


    #
    # attribute names for SummaryInformation stream properties:
    # (ordered by property id, starting at 1)
    #
    SUMMARY_ATTRIBS = [
      "codepage",
      "title",
      "subject",
      "author",
      "keywords",
      "comments",
      "template",
      "last_saved_by",
      "revision_number",
      "total_edit_time",
      "last_printed",
      "create_time",
      "last_saved_time",
      "num_pages",
      "num_words",
      "num_chars",
      "thumbnail",
      "creating_application",
      "security"
    ]

    #
    # attribute names for DocumentSummaryInformation stream properties:
    # (ordered by property id, starting at 1)
    #
    DOCSUM_ATTRIBS = [
      "codepage_doc",
      "category",
      "presentation_target",
      "bytes",
      "lines",
      "paragraphs",
      "slides",
      "notes",
      "hidden_slides",
      "mm_clips",
      "scale_crop",
      "heading_pairs",
      "titles_of_parts",
      "manager",
      "company",
      "links_dirty",
      "chars_with_spaces",
      "unused",
      "shared_doc",
      "link_base",
      "hlinks",
      "hlinks_changed",
      "version",
      "dig_sig",
      "content_type",
      "content_status",
      "language",
      "doc_version"
    ]

    property nr_pages : Int32 = 0

    #
    # properties from SummaryInformation stream
    #
    property codepage             : String = ""
    property title                : String = ""
    property subject              : String = ""
    property author               : String = ""
    property keywords             : Array(String) = [] of String
    property comments             : Array(String) = [] of String
    property template             : String = ""
    property last_saved_by        : Time = Time.utc # String = ""
    property revision_number      : Int32 = 0
    property total_edit_time      : Time = Time.utc # String = ""
    property last_printed         : Time = Time.utc # String = ""
    property create_time          : Time = Time.utc # String = ""
    property last_saved_time      : Time = Time.utc # String = ""
    property num_pages            : String = ""
    property num_words            : Int32 = 0
    property num_chars            : Int32 = 0
    property thumbnail            : String = ""
    property creating_application : String = ""
    property security             : String = ""

    #
    # properties from DocumentSummaryInformation stream
    #
    property codepage_doc        : None = 0
    property category            : None = 0
    property presentation_target : None = 0
    property bytes               : None = 0
    property lines               : None = 0
    property paragraphs          : None = 0
    property slides              : None = 0
    property notes               : None = 0
    property hidden_slides       : None = 0
    property mm_clips            : None = 0
    property scale_crop          : None = 0
    property heading_pairs       : None = 0
    property titles_of_parts     : None = 0
    property manager             : String = ""
    property company             : String = ""
    property links_dirty         : None = 0
    property chars_with_spaces   : None = 0
    property unused              : None = 0
    property shared_doc          : None = 0
    property link_base           : None = 0
    property hlinks              : None = 0
    property hlinks_changed      : None = 0
    property version             : None = 0
    property dig_sig             : None = 0
    property content_type        : None = 0
    property content_status      : None = 0
    property language            : String = ""
    property doc_version         : String = ""


  end
end

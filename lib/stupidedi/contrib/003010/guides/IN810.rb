# frozen_string_literal: true
module Stupidedi
  module Contrib
    module ThirtyTen
      module Guides

        b = GuideBuilder
        d = Schema
        r = SegmentReqs
        e = ElementReqs
        s = Versions::FunctionalGroups::ThirtyTen::SegmentDefs
        t = Contrib::ThirtyTen::TransactionSetDefs

        #
        # Invoice Guide WIP
        # #
        # IN810 = b.build(t::IN810,
        #   d::TableDef.header("Heading",
        #     b::Segment(10, s:: ST, "Transaction Set Header",
        #       r::Required, d::RepeatCount.bounded(1),
        #       b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("810")),
        #       b::Element(e::Required,    "Transaction Set Control Number")),

        #     b::Segment(20, s::BEG, "Beginning Segment for Purchase Order",
        #       r::Required, d::RepeatCount.bounded(1),
        #       b::Element(e::Required,    "Transaction Set Purpose Code", b::Values("00","05","18")),
        #       b::Element(e::Required,    "Purchase Order Type Code", b::Values("BE","BK","SP")),
        #       b::Element(e::Required,    "Purchase Order Number"),
        #       b::Element(e::Situational, "Release Number - Purchase Order Sequence Number"),
        #       b::Element(e::Situational, "Purchase Order Date")),

        #   d::TableDef.detail("Detail",
        #     d::LoopDef.build("PO1", d::RepeatCount.bounded(100000),
        #       b::Segment(10, s::PO1, "Purchase Order Baseline Item Data",
        #         r::Required, d::RepeatCount.bounded(1),
        #         b::Element(e::Situational, "Assigned Identification - Purchase Order Line Number"),
        #         b::Element(e::Required,    "Quantity Ordered"),
        #         b::Element(e::Required,    "Unit or Basis for Measurement Code",b::Values("EA")),
        #         b::Element(e::Situational, "Unit Price"),
        #         b::Element(e::NotUsed, "Unknown"),
        #         b::Element(e::Situational, "Product/Service ID Qualifier - Buyer's Part Number Qualifier",b::Values("BP")),
        #         b::Element(e::Situational, "Product/Service ID - Nissan Part Number"),
        #         b::Element(e::Situational, "Product/Service ID Qualifier",b::Values("C4")),
        #         b::Element(e::Situational, "Product/Service ID - Design Note Number")),

        #       d::LoopDef.build("PID", d::RepeatCount.bounded(1),
        #         b::Segment( 50, s::PID, "Product/Item Description",
        #           r::Situational, d::RepeatCount.bounded(1),
        #           b::Element(e::Required,    "Item Description Type", b::Values("F")),
        #           b::Element(e::NotUsed,     "Unknown"),
        #           b::Element(e::NotUsed,     "Unknown"),
        #           b::Element(e::NotUsed,     "Unknown"),
        #           b::Element(e::Situational, "Description - Part Description"))),

        #   d::TableDef.header("Summary",
        #     b::Segment(10, s::CTT, "Transaction Totals",
        #       r::Required, d::RepeatCount.bounded(1),
        #       b::Element(e::Required,    "Number of Line Items")),
        #     b::Segment(30, s::SE, "Transaction Set Trailer",
        #       r::Required, d::RepeatCount.bounded(1),
        #       b::Element(e::Required,    "Number of Included Segments"),
        #       b::Element(e::Required,    "Transaction Set Control Number"))))
      end
    end
  end
end

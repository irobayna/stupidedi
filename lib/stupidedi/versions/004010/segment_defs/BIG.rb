# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        BIG = s::SegmentDef.build(:BIG, "Beginning Segment for Invoice",
          "To indicate the beginning of the Invoice Transaction Set and
          transmit identifying numbers and dates",
          e::E32.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E76.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E32.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E324.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E328.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E1716.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E640.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E353.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E306.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E76.simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end
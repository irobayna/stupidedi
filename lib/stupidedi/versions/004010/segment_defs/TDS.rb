# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        TDS = s::SegmentDef.build(:TDS, "Total Monetary Value Summary",
          "Total Monetary Value Summary",
          e::E610.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E610.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E610.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E610.simple_use(r::Optional,   s::RepeatCount.bounded(1))
          )
      end
    end
  end
end
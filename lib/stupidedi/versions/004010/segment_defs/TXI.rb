# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        TXI = s::SegmentDef.build(:TXI, "Tax Information",
          "Tax Information",
          e::E1724.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E782.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E954.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E1725.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1726.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E1727.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1728.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1729.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1730.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1731.simple_use(r::Optional,   s::RepeatCount.bounded(1))
          )
      end
    end
  end
end
# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        SAC = s::SegmentDef.build(:SAC, "Service, Promotion, Allowance, or Charge Information",
          "To indicate the header charge information",
          e::E1717.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E1718.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E559.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E1719.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1720.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E954.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1721.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E355.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E380.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E380.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1722.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E127.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1723.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E352.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E819.simple_use(r::Optional,   s::RepeatCount.bounded(1))
          )
      end
    end
  end
end
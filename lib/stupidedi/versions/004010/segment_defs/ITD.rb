# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        ITD = s::SegmentDef.build(:ITD, "Terms of Sale/Deferred Terms of Sale",
          "Terms of Sale/Deferred Terms of Sale",
          e::E1733.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E1734.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E954.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E1735.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1736.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E1737.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1738.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1739.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1740.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1741.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E954.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E352.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1742.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1743.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E954.simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end
# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        IT1 = s::SegmentDef.build(:IT1, "Baseline Item Data (Invoice)",
          "Invoice Lines",
          e::E1731.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E1732.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E355.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E212.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E639.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E235.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E234.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E235.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E234.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E235.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E234.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E235.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E234.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E235.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E234.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E235.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E234.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E235.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E234.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E235.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E234.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E235.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E234.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E235.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E234.simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end
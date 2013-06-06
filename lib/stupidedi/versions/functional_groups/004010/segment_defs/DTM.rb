module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          DTM = s::SegmentDef.build(:DTM, "Date/Time Reference",
            "To specify pertinent dates and times",
            e::E374 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            SyntaxNotes::R.build(2) #also 3, 5
            #SyntaxNotes::C.build(4, 3),
            #SyntaxNotes::C.build(5, 6)
          )
        end
      end
    end
  end
end

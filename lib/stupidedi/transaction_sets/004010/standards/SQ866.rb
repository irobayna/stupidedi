# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FortyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        SQ866 = b.build("SQ", "866", "Production Sequence",
          d::TableDef.header("1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BSS.use( 20, r::Mandatory, d::RepeatCount.bounded(1))),

          d::TableDef.detail("2 - Detail",
            d::LoopDef.build("DTM", d::RepeatCount.bounded(100),
              s::DTM.use(110, r::Mandatory, d::RepeatCount.bounded(1)),

              d::LoopDef.build("LIN", d::RepeatCount.unbounded,
                s::LIN.use(150, r::Optional, d::RepeatCount.bounded(1)),
                s::REF.use(160, r::Optional,  d::RepeatCount.unbounded),
                s::QTY.use(170, r::Optional,  d::RepeatCount.bounded(1))))),

          d::TableDef.summary("3 - Summary",
            s::CTT.use(195, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: SE.use(200, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  module Contrib
    module ThirtyTen
      module TransactionSetDefs

        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        IN810 = d::TransactionSetDef.build("IN", "810", "Invoice",
          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)   ),
            s::BEG.use( 20, r::Mandatory, d::RepeatCount.bounded(1)   ),
            s::NTE.use( 30, r::Optional,  d::RepeatCount.bounded(100) ),
            s::CUR.use( 40, r::Optional,  d::RepeatCount.bounded(1)   ),
            s::REF.use( 50, r::Optional,  d::RepeatCount.bounded(12)  ),
            s::PER.use( 60, r::Optional,  d::RepeatCount.bounded(3)   ),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              s:: N1.use( 070, r::Optional, d::RepeatCount.bounded(1)   ),
              s:: N2.use( 080, r::Optional, d::RepeatCount.bounded(2)   ),
              s:: N3.use( 090, r::Optional, d::RepeatCount.bounded(2)   ),
              s:: N4.use( 100, r::Optional, d::RepeatCount.bounded(1)   ),
              s:: REF.use( 110, r::Optional, d::RepeatCount.bounded(12)  ),
              s:: PER.use( 120, r::Optional, d::RepeatCount.bounded(3)   ),
              s:: DMG.use( 125, r::Optional, d::RepeatCount.bounded(1)   ),
              s:: ITD.use( 130, r::Optional, d::RepeatCount.bounded(1)   ),
              s:: DTM.use( 140, r::Optional, d::RepeatCount.bounded(10)  ),
              s:: FOB.use( 150, r::Optional, d::RepeatCount.bounded(1)   ),
              s:: PID.use( 160, r::Optional, d::RepeatCount.bounded(200) ))),

          d::TableDef.detail("Table 2 - Detail",
            d::LoopDef.build("IT1", d::RepeatCount.bounded(200000),
              s::IT1.use( 010, r::Optional, d::RepeatCount.bounded(1)  ),
              s::CTP.use( 050, r::Optional, d::RepeatCount.bounded(25) ),
              s::PAM.use( 055, r::Optional, d::RepeatCount.bounded(10) ),

            d::LoopDef.build("PID", d::RepeatCount.bounded(1000),
              s::PID.use( 060, r::Optional, d::RepeatCount.bounded(1) )))),

          d::TableDef.summary("Table 3 - Summary",
            s::TDS.use( 010, r::Mandatory, d::RepeatCount.bounded(1) ),
            s::TXI.use( 020, r::Optional, d::RepeatCount.bounded(10) )))

      end
    end
  end
end

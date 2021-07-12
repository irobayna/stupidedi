module Stupidedi
  module TransactionSets
    module FortyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        IN810 = b.build("IN", "810", "Invoice",
          d::TableDef.header("1 - Header",
            s::ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BIG.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
            s::REF.use( 30, r::Optional,  d::RepeatCount.bounded(1)),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              s:: N1.use( 110, r::Optional,  d::RepeatCount.bounded(1)),
              s:: N2.use( 120, r::Optional,  d::RepeatCount.bounded(2)),
              s:: N3.use( 130, r::Optional,  d::RepeatCount.bounded(2)),
              s:: N4.use( 140, r::Optional,  d::RepeatCount.unbounded)
              ),

            s::ITD.use( 200, r::Optional, d::RepeatCount.unbounded)  

          ), #end TableDef Header

          d::TableDef.detail("2 - Detail",
            d::LoopDef.build("IT1", d::RepeatCount.bounded(100000),
              s::IT1.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
              s::TXI.use( 20, r::Optional,  d::RepeatCount.bounded(10)),

              d::LoopDef.build("PID", d::RepeatCount.bounded(1000),
                s::PID.use( 30, r::Optional, d::RepeatCount.bounded(1))
                ),

              s::REF.use( 40, r::Optional,  d::RepeatCount.unbounded)
              )  
          ), #end TableDef Detail

          d::TableDef.summary("3 - Summary",
            s::TDS.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::TXI.use( 20, r::Optional, d::RepeatCount.bounded(10)),

            d::LoopDef.build("SAC", d::RepeatCount.bounded(25),
              s:: SAC.use( 30, r::Optional,  d::RepeatCount.bounded(1))
            ),

            s:: CTT.use( 40, r::Optional, d::RepeatCount.bounded(10)),
            s:: SE.use( 50, r::Mandatory, d::RepeatCount.bounded(1))
          ) #end TableDef Summary
        ) #end of build

      end
    end
  end
end

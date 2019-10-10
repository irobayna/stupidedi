using Stupidedi::Refinements

Definitions.segment_defs
  .group_by{|name, _| name.split("::").take_until{|m| m == "SegmentDefs" } }
  .each do |segment_defs, group|
    describe [*segment_defs, "SegmentDefs"].join("::"), :schema do
      describe "#id" do
        specify "matches constant name" do
          group.each do |constant_name, segment_def|
            expect(segment_def.id).to be == constant_name.split("::").last.to_sym
          end
        end
      end

      context "syntax notes" do
        todo "reference existing elements"
        todo "correspond to R(elational) elements"
      end
    end
  end

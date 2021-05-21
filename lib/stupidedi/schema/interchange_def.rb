# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    #
    # @see X12-5.pdf 3.2.1 Basic Interchange Service Request
    # @see X222.pdf B.1.1.4.1 Interchange Control Structures
    #
    class InterchangeDef < AbstractDef
      include Inspect

      # @return [String]
      attr_reader :id

      # @return [Array<SegmentUse>]
      attr_reader :header_segment_uses

      # @return [Array<SegmentUse>]
      attr_reader :trailer_segment_uses

      # @return [Values::InterchangeVal]
      abstract :empty, :args => %w(separators)

      # @return [Reader::Separators]
      abstract :separators, :args => %w(isa_segment_val)

      def initialize(id, header_segment_uses, trailer_segment_uses)
        @id, @header_segment_uses, @trailer_segment_uses =
          id, header_segment_uses, trailer_segment_uses

        @header_segment_uses  = header_segment_uses.map{|x| x.copy(:parent => self) }
        @trailer_segment_uses = trailer_segment_uses.map{|x| x.copy(:parent => self) }
      end

      # @return [InterchangeDef]
      def copy(changes = {})
        InterchangeDef.new \
          changes.fetch(:id, @id),
          changes.fetch(:header_segment_uses, @header_segment_uses),
          changes.fetch(:trailer_segment_uses, @trailer_segment_uses)
      end

      def required?
        false
      end

      # @return [String]
      def descriptor
        "interchange #{id}"
      end

      # @return [SegmentUse]
      def entry_segment_use
        @header_segment_uses.head
      end

      # @return [Array<SegmentUse>]
      def children
        @header_segment_uses + @trailer_segment_uses
      end

      # (see AbstractDef)
      def interchange?
        true
      end

      # @return [void]
      def pretty_print(q)
        q.text("InterchangeDef[#{id}]")
        q.group(2, "(", ")") do
          q.breakable ""
          @header_segment_uses.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end

          unless q.current_group.first?
            q.text ","
            q.breakable
          end
          q.text "... (FUNCTIONAL GROUPS) ..."

          @trailer_segment_uses.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    #
    # @see X222.pdf B.1.1.3.12.5 Data Segments in a Transaction Set
    #
    class SegmentUse < AbstractUse
      include Inspect

      # @see X222 B.1.1.3.12.7 Data Segment Position
      #
      # @return [Integer]
      attr_reader :position

      # @return [SegmentDef]
      attr_reader :definition

      def_delegators :definition, :id, :name, :descriptor

      # @see X222 B.1.1.3.12.6 Data Segment Requirement Designators
      #
      # @return [SegmentReq]
      attr_reader :requirement

      def_delegators :requirement, :required?, :optional?

      # @see X222 B.1.3.12.3 Repeated Occurrences of Single Data Segments
      # @see X222 B.1.3.12.8 Data Segment Occurrence
      #
      # @return [RepeatCount]
      attr_reader :repeat_count

      # @return [LoopDef, TableDef]
      attr_reader :parent

      def initialize(definition, position, requirement, repeat_count, parent)
        @definition, @position, @requirement, @repeat_count, @parent =
          definition, position, requirement, repeat_count, parent

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @definition = @definition.copy(:parent => self)
        end
      end

      # @return [SegmentUse]
      def copy(changes = {})
        SegmentUse.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:position, @position),
          changes.fetch(:requirement, @requirement),
          changes.fetch(:repeat_count, @repeat_count),
          changes.fetch(:parent, @parent)
      end

      def repeatable?
        @repeat_count.try{|r| r.include?(2) }
      end

      # @return [SegmentVal]
      def empty(position)
        definition.empty(self, position)
      end

      def value(element_vals, position)
        definition.value(element_vals, self, position)
      end

      # (see AbstractUse#segment?)
      def segment?
        true
      end

      # @return [void]
      def pretty_print(q)
        q.text "SegmentUse"
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @position
          q.text ","

          q.breakable
          q.pp @definition
          q.text ","

          q.breakable
          q.pp @requirement
          q.text ","

          q.breakable
          q.pp @repeat_count
        end
      end
    end
  end
end

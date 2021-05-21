# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    #
    # @see X222.pdf 2.2.2 Loops
    # @see X222.pdf B.1.3.12.4 Loops of Data Segments
    #
    class LoopDef < AbstractDef
      include Inspect

      # @return [String]
      attr_reader :id

      # @return [RepeatCount]
      attr_reader :repeat_count

      # @return [Array<SegmentUse>]
      attr_reader :header_segment_uses

      # @return [Array<SegmentUse>]
      attr_reader :trailer_segment_uses

      # @return [Array<LoopDef>]
      attr_reader :loop_defs

      # @return [LoopDef, TableDef]
      attr_reader :parent

      def_delegators :entry_segment_use, :requirement

      def_delegators :requirement, :required?, :optional?

      def initialize(id, repeat_count, header_segment_uses, loop_defs, trailer_segment_uses, parent)
        @id, @repeat_count, @header_segment_uses, @loop_defs, @trailer_segment_uses, @parent =
          id, repeat_count, header_segment_uses, loop_defs, trailer_segment_uses, parent

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @header_segment_uses  = @header_segment_uses.map{|x| x.copy(:parent => self) }
          @loop_defs            = @loop_defs.map{|x| x.copy(:parent => self) }
          @trailer_segment_uses = @trailer_segment_uses.map{|x| x.copy(:parent => self) }
        end
      end

      # @return [LoopDef]
      def copy(changes = {})
        LoopDef.new \
          changes.fetch(:id, @id),
          changes.fetch(:repeat_count, @repeat_count),
          changes.fetch(:header_segment_uses, @header_segment_uses),
          changes.fetch(:loop_defs, @loop_defs),
          changes.fetch(:trailer_segment_uses, @trailer_segment_uses),
          changes.fetch(:parent, @parent)
      end

      # @return [String]
      def descriptor
        "loop #{id}"
      end

      def repeatable?
        @repeat_count.try{|r| r.include?(2) }
      end

      # @see X222 B.1.1.3.11.1 Loop Control Segments
      # @see X222 B.1.1.3.12.4 Loops of Data Segments Bounded Loops
      def bounded?
        @header_segment_uses.head.definition.id == :LS and
        @trailer_segment_uses.last.definition.id == :LE
      end

      # @see X12.59 5.6 HL-initiated Loop
      def hierarchical?
        @header_segment_uses.head.definition.id == :HL
      end

      # @return [SegmentUse]
      def entry_segment_use
        @header_segment_uses.head
      end

      # @return [Array<SegmentUse, LoopDef>]
      def children
        @header_segment_uses + @loop_defs + @trailer_segment_uses
      end

      # @return [LoopVal]
      def empty
        Values::LoopVal.new(self, [])
      end

      def loop?
        true
      end

      # @return [void]
      def pretty_print(q)
        q.text("LoopDef[#{@id}]")
        q.group(2, "(", ")") do
          q.breakable ""
          @header_segment_uses.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
          @loop_defs.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
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

    class << LoopDef
      # @group Constructors
      #########################################################################

      # @return [LoopDef]
      def build(id, repeat_count, *children)
        header, children   = children.split_when{|x| x.is_a?(LoopDef) }
        loop_defs, trailer = children.split_when{|x| x.is_a?(SegmentUse) }

        # @todo: Ensure there is at least one SegmentUse in header
        if header.empty?
          raise Exceptions::InvalidSchemaError,
            "first child must be a SegmentUse"
        elsif header.head.repeat_count.include?(2)
          raise Exceptions::InvalidSchemaError,
            "first child must have RepeatCount.bounded(1)"
        end

        trailer.each.with_index do |s, k|
          unless s.segment?
            if s.respond_to?(:pretty_inspect)
              raise Exceptions::InvalidSchemaError,
                "arguments after last child LoopDef (#{loop_defs.last.id})
                must be segments, but #{k+1} arguments later is not a
                SegmentUse: #{s.pretty_inspect}".join
            else
              raise Exceptions::InvalidSchemaError,
                "arguments after last child LoopDef (#{loop_defs.last.id})
                must be segments, but #{k+1} arguments later is not a
                SegmentUse: #{s.inspect}".join
            end
          end
        end

        new(id, repeat_count, header, loop_defs, trailer, nil)
      end

      # @endgroup
      #########################################################################
    end
  end
end

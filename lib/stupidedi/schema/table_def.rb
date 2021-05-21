# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    class TableDef < AbstractDef
      # @return [String]
      attr_reader :id

      # @return [Array<SegmentUse>]
      attr_reader :header_segment_uses

      # @return [Array<SegmentUse>]
      attr_reader :trailer_segment_uses

      # @return [Array<LoopDef>]
      attr_reader :loop_defs

      # @return [TransactionSetDef]
      attr_reader :parent

      # @return [Integer]
      attr_reader :position

      def initialize(id, position, header_segment_uses, loop_defs, trailer_segment_uses, parent)
        @id, @position, @header_segment_uses, @loop_defs, @trailer_segment_uses, @parent =
          id, position, header_segment_uses, loop_defs, trailer_segment_uses, parent

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @header_segment_uses  = @header_segment_uses.map{|x| x.copy(:parent => self) }
          @loop_defs            = @loop_defs.map{|x| x.copy(:parent => self) }
          @trailer_segment_uses = @trailer_segment_uses.map{|x| x.copy(:parent => self) }
        end
      end

      # @return [TableDef]
      def copy(changes = {})
        TableDef.new \
          changes.fetch(:id, @id),
          changes.fetch(:position, @position),
          changes.fetch(:header_segment_uses, @header_segment_uses),
          changes.fetch(:loop_defs, @loop_defs),
          changes.fetch(:trailer_segment_uses, @trailer_segment_uses),
          changes.fetch(:parent, @parent)
      end

      # @return [String]
      def descriptor
        "table #{id}"
      end

      def repeatable?
        @header_segment_uses.empty? and
          @loop_defs.present?       and
          @loop_defs.head.repeatable?
      end

      def repeat_count
        if repeatable?
          RepeatCount.unbounded
        else
          RepeatCount.bounded(1)
        end
      end

      def required?
        entry_segment_uses.any?(&:required?)
      end

      # @return [Array<SegmentUse>]
      def entry_segment_uses
        uses = @header_segment_uses \
             + @loop_defs.map{|l| l.entry_segment_use } \
             + @trailer_segment_uses

        # Up to and including the first required segment
        suffix = uses.drop_while(&:optional?)

        if suffix.present?
          # Some segment(s) is required, so table can't start without it
          position = suffix.map(&:position).min
          uses.take_while{|u| u.position <= position }
        else
          # Nothing is required, table can begin at any of these
          uses
        end
      end

      # @return [Array<SegmentUse, LoopDef>]
      def children
        @header_segment_uses + @loop_defs + @trailer_segment_uses
      end

      # @return [Values::TableVal]
      def empty
        Values::TableVal.new(self, [])
      end

      def table?
        true
      end

      # @return [void]
      def pretty_print(q)
        q.text("TableDef[#{@id}]")
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

    class << TableDef
      # @group Constructors
      #########################################################################

      # @return [TableDef]
      def header(id, *children)
        unless id.is_a?(String)
          raise Exceptions::InvalidSchemaError,
            "first argument to TableDef.header must be a String but got #{id.inspect}"
        end

        header, children   = children.split_when{|x| x.is_a?(LoopDef) }
        loop_defs, trailer = children.split_when{|x| x.is_a?(SegmentUse) }
        new(id, 1, header, loop_defs, trailer, nil)
      end

      # @return [TableDef]
      def detail(id, *children)
        unless id.is_a?(String)
          raise Exceptions::InvalidSchemaError,
            "first argument to TableDef.detail must be a String but got #{id.inspect}"
        end

        header, children   = children.split_when{|x| x.is_a?(LoopDef) }
        loop_defs, trailer = children.split_when{|x| x.is_a?(SegmentUse) }
        new(id, 2, header, loop_defs, trailer, nil)
      end

      # @return [TableDef]
      def summary(id, *children)
        unless id.is_a?(String)
          raise Exceptions::InvalidSchemaError,
            "first argument to TableDef.summary must be a String but got #{id.inspect}"
        end

        header, children   = children.split_when{|x| x.is_a?(LoopDef) }
        loop_defs, trailer = children.split_when{|x| x.is_a?(SegmentUse) }
        new(id, 3, header, loop_defs, trailer, nil)
      end

      # @endgroup
      #########################################################################
    end
  end
end

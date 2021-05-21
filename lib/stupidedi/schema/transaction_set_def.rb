# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    class TransactionSetDef < AbstractDef
      include Inspect

      # @return [String]
      attr_reader :id

      # @return [String]
      attr_reader :name

      # @return [String]
      attr_reader :functional_group

      # @return [Array<TableDef>]
      attr_reader :table_defs

      def initialize(functional_group, id, name, table_defs)
        @functional_group, @id, @name, @table_defs =
          functional_group, id, name, table_defs

        @table_defs = table_defs.map{|x| x.copy(:parent => self) }
      end

      def copy(changes = {})
        TransactionSetDef.new \
          changes.fetch(:functional_group, @functional_group),
          changes.fetch(:id, @id),
          changes.fetch(:name, @name),
          changes.fetch(:table_defs, @table_defs)
      end

      # @return [String]
      def descriptor
        "transaction set #{functional_group}#{id} #{name}"
      end

      # @return [Values::TransactionSetVal]
      def empty
        Values::TransactionSetVal.new(self, [])
      end

      # @return [SegmentUse]
      def entry_segment_use
        @table_defs.head.header_segment_uses.head
      end

      # @return [SegmentUse]
      def first_segment_use
        @table_defs.head.header_segment_uses.head
      end

      # @return [SegmentUse]
      def last_segment_use
        @table_defs.last.trailer_segment_uses.last
      end

      # @return [Array<TableDef>]
      def children
        @table_defs
      end

      def transaction?
        true
      end

      # @return [void]
      def pretty_print(q)
        q.text("TransactionSetDef[#{@functional_group}#{@id}]")
        q.group(2, "(", ")") do
          q.breakable ""
          @table_defs.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end
    end

    class << TransactionSetDef
      # @return [TransactionSetDef]
      def build(functional_group, id, name, *table_defs)
        table_defs.each.with_index do |t, k|
          unless t.table?
            if t.respond_to?(:pretty_inspect)
              raise Exceptions::InvalidSchemaError,
                "argument #{k+4} is not a TableDef: #{t.pretty_inspect}"
            else
              raise Exceptions::InvalidSchemaError,
                "argument #{k+4} is not a TableDef: #{t.inspect}"
            end
          end

          # next unless t.repeatable?

          # [t.header_segment_uses, t.loop_defs, t.trailer_segment_uses].each do |s|
          #   opt, req = s.split_until(&:optional?)
          #   prefix   = opt.concat(req.take(1))

          #   if x = prefix.find(&:repeatable?)
          #     raise Exceptions::InvalidSchemaError,
          #       %Q("#{x.id}" is an entry point into "#{t.id}", and both are marked
          #       repeatable).join
          #   end

          #   break if req.present?
          # end
        end

        new(functional_group, id, name, table_defs)
      end
    end
  end
end

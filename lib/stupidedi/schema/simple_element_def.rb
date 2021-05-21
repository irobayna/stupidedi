# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    #
    # @see X222 B.1.1.3.1 Data Element
    #
    class SimpleElementDef < AbstractElementDef
      # @return [SimpleElementUse, ComponentElementUse]
      abstract :parent

      # @return [SimpleElementVal]
      abstract :empty, :args => %w(position)

      # @return [SimpleElementVal]
      abstract :value, :args => %w(object position)

      # @return [SimpleElementVal]
      abstract :parse, :args => %w(string position)

      # @return true
      def simple?
        true
      end

      # @return false
      def composite?
        false
      end

      # @return [SimpleElementUse]
      def simple_use(requirement, repeat_count, parent = nil)
        SimpleElementUse.new(self, requirement, repeat_count, Sets.universal, parent)
      end

      # @return [ComponentElementUse]
      def component_use(requirement, parent = nil)
        ComponentElementUse.new(self, requirement, Sets.universal, parent)
      end
    end
  end
end

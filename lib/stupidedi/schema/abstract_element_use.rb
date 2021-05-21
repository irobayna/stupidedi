# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    class AbstractElementUse < AbstractUse
      include Inspect

      def_delegators :requirement, :forbidden?, :required?, :optional?

      def_delegators :definition

      # @return [Symbol]
      abstract :id

      # @return [String]
      abstract :name

      # @return [String]
      abstract :description

      # @return [ElementReq]
      abstract :requirement

      # @return [SimpleElementDef, CompositeElementDef]
      abstract :definition

      abstract :simple?

      abstract :component?

      # @return [SimpleElementVal, CompositeElementVal]
      def empty(position)
        definition.empty(self, position)
      end

      # @return [SimpleElementVal, CompositeElementVal]
      def value(object, position)
        definition.value(object, self, position)
      end

      def composite?
        not simple?
      end
    end
  end
end

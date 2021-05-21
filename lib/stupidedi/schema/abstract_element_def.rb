# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    class AbstractElementDef < AbstractDef
      include Inspect

      # @return [String]
      attr_reader :id

      # @return [String]
      attr_reader :name

      # @return [String]
      attr_reader :description

      abstract :simple?

      abstract :composite?


      # @return [String]
      def descriptor
        "element #{id} #{description}".strip
      end

      def element?
        true
      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    class CodeList
      include Inspect

      abstract :external?

      def internal?
        not external?
      end

      class Internal < CodeList
        attr_reader :hash

        def_delegators :hash, :at, :defined_at?

        def initialize(hash)
          @hash = hash
        end

        # @return [Array<String>]
        def codes
          hash.keys
        end

        def external?
          false
        end
      end

      class External < CodeList
        attr_reader :id

        def_delegators :code_dictionary, :at, :defined_at?

        def initialize(id)
          @id = id
        end

        def codes
          code_dictionary.keys
        end

        def external?
          true
        end

        def to_str
          "CodeList.external(#{@id})"
        end

        private

        def code_dictionary
          Stupidedi.external_code_lists.fetch(id)
        end
      end
    end

    class << CodeList
      # @group Constructors
      #########################################################################

      # @return [CodeList::Internal]
      def build(hash)
        # @todo: deprecate
        CodeList::Internal.new(hash)
      end

      # @return [CodeList::Internal]
      def internal(hash)
        CodeList::Internal.new(hash)
      end

      # @return [CodeList::External]
      def external(id, *ignored)
        CodeList::External.new(id)
      end

      # @endgroup
      #########################################################################
    end
  end
end

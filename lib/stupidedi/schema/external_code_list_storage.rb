# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    class ExternalCodeListStorage
      attr_reader :storage

      def_delegators :storage, :fetch, :empty?

      def initialize(storage)
        @storage = storage
      end

      def register(id, repository)
        if storage.has_key?(id)
          warn "You are trying to override an existing external code list with id: #{id}. Please make sure each external code list is registered once."
        end

        storage[id] = repository
      end

      def fetch(id)
        storage.fetch(id, Hash.new)
      end

      class << self
        def empty
          self.new(Hash.new)
        end
      end
    end
  end
end

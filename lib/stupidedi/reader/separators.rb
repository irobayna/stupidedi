# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader
    #
    # Stores the separators used to tokenize X12 from an input stream and
    # serialize it to an output stream.
    #
    # @see X222.pdf B.1.1.2.5 Delimiters
    #
    class Separators
      # @return [String]
      attr_accessor :component  # :

      # @return [String]
      attr_accessor :repetition # ^

      # @return [String]
      attr_accessor :element    # *

      # @return [String]
      attr_accessor :segment    # ~

      def initialize(component, repetition, element, segment)
        @component, @repetition, @element, @segment =
          component, repetition, element, segment
      end

      # True if all separators are `#blank?`
      def blank?
        @component.blank?   and
        @repetition.blank?  and
        @element.blank?     and
        @segment.blank?
      end

      # True if any one separator is not `#blank?`
      def present?
        not blank?
      end

      # @return [Separators]
      def copy(changes = {})
        Separators.new \
          changes.fetch(:component, @component),
          changes.fetch(:repetition, @repetition),
          changes.fetch(:element, @element),
          changes.fetch(:segment, @segment)
      end

      # Creates a new value that has the separators from `other`, when they
      # are not nil, and will use separators from `self` otherwise.
      #
      # @return [Separators]
      def merge(other)
        Separators.new \
          other.component  || @component,
          other.repetition || @repetition,
          other.element    || @element,
          other.segment    || @segment
      end

      # Indicates if the given char is among one of the separators
      #
      # @return [Boolean]
      def include?(char)
        @component  == char ||
        @repetition == char ||
        @element    == char ||
        @segment    == char
      end

      # @return [AbstractSet<String>]
      def characters
        chars =
          [@component, @repetition, @element, @segment].select{|s| s.present? }

        Sets.absolute(chars.join.split(//), Reader::C_BYTES.split(//))
      end

      # @return [String]
      def inspect
        "Separators(#{@component.inspect}, #{@repetition.inspect}, #{@element.inspect}, #{@segment.inspect})"
      end
    end

    class << Separators
      # @group Constructors
      #########################################################################

      # @return [Separators]
      def blank
        new(nil, nil, nil, nil)
      end

      # @return [Separators]
      def build(hash)
        Separators.new \
          hash[:component],
          hash[:repetition],
          hash[:element],
          hash[:segment]
      end

      # @return [Separators]
      def default
        Separators.new(":", "^", "*", "~")
      end

      # @endgroup
      #########################################################################
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module Common
      module ElementTypes
        class ID < SimpleElementDef
          # @return [Schema::CodeList]
          attr_reader :code_list

          def initialize(id, name, min_length, max_length, code_list = nil, description = nil, parent = nil)
            super(id, name, min_length, max_length, description, parent)
            @code_list = code_list
          end

          def companion
            IdentifierVal
          end

          # @return [ID]
          def copy(changes = {})
            ID.new \
              changes.fetch(:id, @id),
              changes.fetch(:name, @name),
              changes.fetch(:min_length, @min_length),
              changes.fetch(:max_length, @max_length),
              changes.fetch(:code_list, @code_list),
              changes.fetch(:description, @description),
              changes.fetch(:parent, @parent)
          end

          # @return [SimpleElementUse]
          def simple_use(requirement, repeat_count, parent = nil)
            if @code_list.try(:internal?)
              Schema::SimpleElementUse.new(self, requirement, repeat_count, Sets.absolute(@code_list.codes), parent)
            else
              Schema::SimpleElementUse.new(self, requirement, repeat_count, Sets.universal, parent)
            end
          end

          # @return [ComponentElementUse]
          def component_use(requirement, parent = nil)
            if @code_list.try(:internal?)
              Schema::ComponentElementUse.new(self, requirement, Sets.absolute(@code_list.codes), parent)
            else
              Schema::ComponentElementUse.new(self, requirement, Sets.universal, parent)
            end
          end
        end

        #
        # @see X222.pdf B.1.1.3.1.3 Identifier
        #
        class IdentifierVal < Values::SimpleElementVal
          def id?
            true
          end

          def too_long?
            false
          end

          def too_short?
            false
          end

          class Invalid < IdentifierVal
            # @return [Object]
            attr_reader :value

            def initialize(value, usage, position)
              @value = value
              super(usage, position)
            end

            # @return [Invalid]
            def copy(changes = {})
              self
            end

            def valid?
              false
            end

            def empty?
              false
            end

            # @return [IdentifierVal]
            def map
              self
            end

            # @return [String]
            # :nocov:
            def inspect
              id = definition.bind do |d|
                "[#{"% 5s" % d.id}: #{d.name}]".bind do |s|
                  if usage.forbidden?
                    ansi.forbidden(s)
                  elsif usage.required?
                    ansi.required(s)
                  else
                    ansi.optional(s)
                  end
                end
              end

              ansi.element("ID.invalid#{id}") + "(#{ansi.invalid(@value.inspect)})"
            end
            # :nocov:

            # @return [String]
            def to_s
              ""
            end

            # @return [String]
            def to_x12(truncate = true)
              ""
            end

            # @return [Boolean]
            def ==(other)
              eql?(other)
            end
          end

          class Valid < IdentifierVal
            include Comparable

            # (string any* -> any)
            def_delegators :value, :to_d, :to_s, :to_f, :to_c, :to_r, :to_sym,
              :to_str, :hex, :oct, :ord, :sum, :length, :count, :index, :rindex,
              :lines, :bytes, :chars, :each, :upto, :split, :scan, :unpack, :=~,
              :match, :partition, :rpatition, :encoding, :valid_enocding?,
              :at, :empty?, :blank?

            # (string any* -> StringVal)
            extend Operators::Wrappers
            wrappers :%, :+, :*, :slice, :take, :drop, :[], :capitalize,
              :center, :ljust, :rjust, :chomp, :delete, :tr, :tr_s,
              :sub, :gsub, :encode, :force_encoding, :squeeze

            # (string -> StringVal)
            extend Operators::Unary
            unary_operators :chr, :chop, :upcase, :downcase, :strip,
              :lstrip, :rstrip, :dump, :succ, :next, :reverse, :swapcase

            # (string string -> any)
            extend Operators::Relational
            relational_operators :<=>, :start_with?, :end_with?,
              :include?, :casecmp, :coerce => :to_str

            def ==(other)
              other = IdentifierVal.value(other, usage, position)
              other.valid? and other.value == value
            end

            # @return [StringVal]
            def copy(changes = {})
              IdentifierVal.value \
                changes.fetch(:value, value),
                changes.fetch(:usage, usage),
                changes.fetch(:position, position)
            end

            def coerce(other)
              return IdentifierVal.value(other, usage, position), self
            end

            # @return [IdentifierVal]
            def map
              IdentifierVal.value(yield(value), usage, position)
            end

            def valid?
              true
            end
          end

          class Empty < Valid
            # @return [String]
            def value
              ""
            end

            # @return [String]
            # :nocov:
            def inspect
              id = definition.bind do |d|
                "[#{"% 5s" % d.id}: #{d.name}]".bind do |s|
                  if usage.forbidden?
                    ansi.forbidden(s)
                  elsif usage.required?
                    ansi.required(s)
                  else
                    ansi.optional(s)
                  end
                end
              end

              ansi.element("ID.empty#{id}")
            end
            # :nocov:

            # @return [String]
            def to_x12(truncate = true)
              ""
            end
          end

          class NonEmpty < Valid
            # @return [String]
            attr_reader :value

            def initialize(value, usage, position)
              @value = value
              super(usage, position)
            end

            def too_long?
              @value.length > definition.max_length
            end

            def too_short?
              @value.length < definition.min_length
            end

            # @return [String]
            def to_x12(truncate = true)
              x12 = @value.ljust(definition.min_length, " ")
              truncate ? x12.take(definition.max_length) : x12
            end

            # @return [String]
            # :nocov:
            def inspect
              id = definition.bind do |d|
                "[#{"% 5s" % d.id}: #{d.name}]".bind do |s|
                  if usage.forbidden?
                    ansi.forbidden(s)
                  elsif usage.required?
                    ansi.required(s)
                  else
                    ansi.optional(s)
                  end
                end
              end

              if definition.code_list.try(&:internal?)
                if usage.allowed_values.include?(@value)
                  value = "#{@value}: " + ansi.dark(definition.code_list.at(@value))
                elsif definition.code_list.defined_at?(@value)
                  value = ansi.red("#{@value}: " + definition.code_list.at(@value))
                else
                  value = ansi.red(@value)
                end
              elsif definition.code_list.try(&:external?)
                if definition.code_list.defined_at?(@value)
                  value = "#{@value}: " + ansi.dark(definition.code_list.at(@value))
                else
                  value = ansi.red(@value)
                end
              else
                value = @value
              end

              ansi.element("ID.value#{id}") + "(#{value})"
            end
            # :nocov:
          end
        end

        class << IdentifierVal
          # @group Constructors
          ###################################################################

          # @return [IdentifierVal]
          def empty(usage, position)
            self::Empty.new(usage, position)
          end

          # @return [IdentifierVal]
          def value(object, usage, position)
            if object.is_a?(IdentifierVal)
              object#.copy(:usage => usage, :position => position)
            elsif object.blank?
              self::Empty.new(usage, position)
            else
              self::NonEmpty.new(object.to_s.rstrip, usage, position)
            end
          rescue
            self::Invalid.new(object, usage, position)
          end

          # @endgroup
          ###################################################################
        end

        # Prevent direct instantiation of abstract class IdentifierVal
        IdentifierVal.eigenclass.send(:protected, :new)
        IdentifierVal::Empty.eigenclass.send(:public, :new)
        IdentifierVal::Invalid.eigenclass.send(:public, :new)
        IdentifierVal::NonEmpty.eigenclass.send(:public, :new)
      end
    end
  end
end

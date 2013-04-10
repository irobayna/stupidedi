module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module ElementTypes

          class AN < SimpleElementDef
            def companion
              StringVal
            end
          end

          #
          # @see X222.pdf A.1.3.1.4 String
          #
          class StringVal < Values::SimpleElementVal

            def string?
              true
            end

            def too_long?
              false
            end

            def too_short?
              false
            end

            #
            # Objects passed to StringVal.value that don't respond to #to_s are
            # modeled by this class. Note most everything in Ruby responds to
            # that method, including things that really shouldn't be considered
            # StringVals (like Array or Class), so other validation should be
            # performed on StringVal::NonEmpty values.
            #
            class Invalid < StringVal

              # @return [Object]
              attr_reader :value

              def initialize(value, usage, position)
                @value = value
                super(usage, position)
              end

              def valid?
                false
              end

              def empty?
                false
              end

              # @return [String]
              def inspect
                id = definition.bind do |d|
                  "[#{'% 5s' % d.id}: #{d.name}]".bind do |s|
                    if usage.forbidden?
                      ansi.forbidden(s)
                    elsif usage.required?
                      ansi.required(s)
                    else
                      ansi.optional(s)
                    end
                  end
                end

                ansi.element("AN.invalid#{id}") << "(#{ansi.invalid(@value.inspect)})"
              end

              # @return [String]
              def to_s
                ""
              end

              # @return [Boolean]
              def ==(other)
                eql?(other) or
                  (other.is_a?(Invalid) and @value == other.value)
              end
            end

            #
            # Empty string value. Shouldn't be directly instantiated -- instead,
            # use the {StringVal.empty} constructor.
            #
            class Empty < StringVal

              def valid?
                true
              end

              def empty?
                true
              end

              # @return [String]
              def inspect
                id = definition.bind do |d|
                  "[#{'% 5s' % d.id}: #{d.name}]".bind do |s|
                    if usage.forbidden?
                      ansi.forbidden(s)
                    elsif usage.required?
                      ansi.required(s)
                    else
                      ansi.optional(s)
                    end
                  end
                end

                ansi.element("AN.empty#{id}")
              end

              # @return [String]
              def to_s
                ""
              end

              # @return [Boolean]
              def ==(other)
                other.is_a?(Empty)
              end
            end

            #
            # Non-empty string value. Shouldn't be directly instantiated --
            # instead, use the {StringVal.value} constructor.
            #
            class NonEmpty < StringVal

              # @return [String]
              attr_reader :value

              delegate_stupid :to_d, :to_s, :to_f, :length, :=~, :match, :to => :@value

              def initialize(string, usage, position)
                @value = string
                super(usage, position)
              end

              # @return [NonEmpty]
              def copy(changes = {})
                NonEmpty.new \
                  changes.fetch(:value, @value),
                  changes.fetch(:usage, usage),
                  changes.fetch(:position, position)
              end

              def too_long?
                @value.lstrip.length > definition.max_length
              end

              def too_short?
                @value.lstrip.length < definition.min_length
              end

              # @return [String]
              def inspect
                id = definition.bind do |d|
                  "[#{'% 5s' % d.id}: #{d.name}]".bind do |s|
                    if usage.forbidden?
                      ansi.forbidden(s)
                    elsif usage.required?
                      ansi.required(s)
                    else
                      ansi.optional(s)
                    end
                  end
                end

                ansi.element("AN.value#{id}") << "(#{@value})"
              end

              def valid?
                true
              end

              def empty?
                false
              end

              # @return [StringVal::NonEmpty]
              def gsub(*args, &block)
                copy(:value => @value.gsub(*args, &block))
              end

              # @return [StringVal::NonEmpty]
              def upcase
                copy(:value => @value.upcase)
              end

              # @return [StringVal::NonEmpty]
              def downcase
                copy(:value => @value.downcase)
              end

              def to_date(format)
                case format
                when "D8"  # CCYYMMDD
                  Date.civil(@value.slice(0, 4).to_i, # year
                             @value.slice(4, 2).to_i, # month
                             @value.slice(6, 2).to_i) # day
                when "DB"  # MMDDCCYY
                  Date.civil(@value.slice(4, 4).to_i,
                             @value.slice(0, 2).to_i,
                             @value.slice(2, 2).to_i)
                when "DDT" # CCYYMMDD-CCYYMMDDHHMM
                  Time.utc(@value.slice(0, 4).to_i,     # year
                           @value.slice(4, 2).to_i,     # month
                           @value.slice(6, 2).to_i) ..  # day
                  Time.utc(@value.slice(9, 4).to_i,
                           @value.slice(13, 2).to_i,
                           @value.slice(15, 2).to_i,
                           @value.slice(17, 2).to_i,    # hour
                           @value.slice(19, 2).to_i)    # minute
                when "DT"  # CCYYMMDDHHMM
                  Time.utc(@value.slice(0, 4).to_i,
                           @value.slice(4, 2).to_i,
                           @value.slice(6, 2).to_i,
                           @value.slice(8, 2).to_i,
                           @value.slice(10, 2).to_i)
                when "DTD" # CCYYMMDDHHMM-CCYYMMDD
                  Time.utc(@value.slice(0, 4).to_i,
                           @value.slice(4, 2).to_i,
                           @value.slice(6, 2).to_i,
                           @value.slice(8, 2).to_i,
                           @value.slice(10, 2).to_i) ..
                  Time.utc(@value.slice(13, 4).to_i,
                           @value.slice(15, 2).to_i,
                           @value.slice(17, 2).to_i)
                when "DTS" # CCYYMMDDHHMMSS-CCYYMMDDHHMMSS
                  Time.utc(@value.slice(0, 4).to_i,
                           @value.slice(4, 2).to_i,
                           @value.slice(6, 2).to_i,
                           @value.slice(8, 2).to_i,
                           @value.slice(10, 2).to_i,
                           @value.slice(12, 2).to_i) ..
                  Time.utc(@value.slice(15, 4).to_i,
                           @value.slice(19, 2).to_i,
                           @value.slice(21, 2).to_i,
                           @value.slice(23, 2).to_i,
                           @value.slice(25, 2).to_i,
                           @value.slice(27, 2).to_i)
                when "RD"  # MMDDCCYY-MMDDCCYY
                  Date.civil(@value.slice(4, 4).to_i,
                             @value.slice(0, 2).to_i,
                             @value.slice(2, 2).to_i) ..
                  Date.civil(@value.slice(13, 4).to_i,
                             @value.slice(9, 2).to_i,
                             @value.slice(11, 2).to_i)
                when "RD8" # CCYYMMDD-CCYYMMDD
                  Date.civil(@value.slice(0, 4).to_i,
                             @value.slice(4, 2).to_i,
                             @value.slice(6, 2).to_i) ..
                  Date.civil(@value.slice(9, 4).to_i,
                             @value.slice(11, 2).to_i,
                             @value.slice(13, 2).to_i)
                when "RDT" # CCYYMMDDHHMM-CCYYMMDDHHMM
                  Time.utc(@value.slice(0, 4).to_i,
                           @value.slice(4, 2).to_i,
                           @value.slice(6, 2).to_i,
                           @value.slice(8, 2).to_i,
                           @value.slice(10, 2).to_i) ..
                  Time.utc(@value.slice(13, 4).to_i,
                           @value.slice(15, 2).to_i,
                           @value.slice(17, 2).to_i,
                           @value.slice(19, 2).to_i,
                           @value.slice(21, 2).to_i)
                when "RTS" # CCYYMMDDHHMMSS
                  Time.utc(@value.slice(0, 4).to_i,
                           @value.slice(4, 2).to_i,
                           @value.slice(6, 2).to_i,
                           @value.slice(8, 2).to_i,
                           @value.slice(10, 2).to_i)
                else
                  raise ArgumentError,
                    "Format code #{format} is not recognized"
                end
              end

              # @return [Boolean]
              def ==(other)
                eql?(other) or
                 (if other.is_a?(NonEmpty)
                    other.value == @value
                  else
                    other == @value
                  end)
              end
            end

          end

          class << StringVal
            # @group Constructors
            ###################################################################

            # @return [StringVal]
            def empty(usage, position)
              self::Empty.new(usage, position)
            end

            # @return [StringVal]
            def value(object, usage, position)
              if object.blank?
                self::Empty.new(usage, position)
              elsif object.respond_to?(:to_s)
                self::NonEmpty.new(object.to_s.rstrip, usage, position)
              else
                self::Invalid.new(object, usage, position)
              end
            end

            # @return [StringVal]
            def parse(string, usage, position)
              if string.blank?
                self::Empty.new(usage, position)
              else
                self::NonEmpty.new(string.rstrip, usage, position)
              end
            end

            # @endgroup
            ###################################################################
          end

          # Prevent direct instantiation of abstract class StringVal
          StringVal.eigenclass.send(:protected, :new)
          StringVal::Empty.eigenclass.send(:public, :new)
          StringVal::Invalid.eigenclass.send(:public, :new)
          StringVal::NonEmpty.eigenclass.send(:public, :new)
        end

      end
    end
  end
end

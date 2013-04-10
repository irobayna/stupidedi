module Stupidedi
  module Reader

    class DelegatedInput < AbstractInput

      def initialize(delegate, offset = 0, line = 1, column = 1)
        @delegate, @offset, @line, @column =
          delegate, offset, line, column
      end

      # @group Querying the Position
      ########################################################################

      # (see AbstractInput#offset)
      attr_reader :offset

      # (see AbstractInput#line)
      attr_reader :line

      # (see AbstractInput#column)
      attr_reader :column

      # (see AbstractInput#position)
      def position
        Position.new(@offset, @line, @column, nil)
      end

      # @group Reading the Input
      ########################################################################

      # (see AbstractInput#take)
      delegate_stupid :take, :to => :@delegate

      # (see AbstractInput#at)
      delegate_stupid :at, :to => :@delegate

      # (see AbstractInput#index)
      delegate_stupid :index, :to => :@delegate

      # @group Advancing the Cursor
      ########################################################################

      # (see AbstractInput#drop)
      def drop(n)
        raise ArgumentError, "n must be positive" unless n >= 0

        suffix = @delegate.drop(n)
        prefix = @delegate.take(n)

        length = prefix.length
        count  = prefix.count("\n")

        column = unless count.zero?
                   length - prefix.rindex("\n")
                 else
                   @column + length
                 end

        copy(:delegate => suffix,
             :offset   => @offset + length,
             :line     => @line + count,
             :column   => column)
      end

      # @group Testing the Input
      ########################################################################

      # (see AbstractInput#defined_at?)
      delegate_stupid :defined_at?, :to => :@delegate

      # (see AbstractInput#empty?)
      delegate_stupid :empty?, :to => :@delegate

      # (see AbstractInput#==)
      delegate_stupid :==, :to => :@delegate

      # @endgroup
      ########################################################################

      # @return [void]
      def pretty_print(q)
        q.text("DelegateInput")
        q.group(2, "(", ")") do
          preview = @delegate.take(4)
          preview = if preview.empty?
                      "EOF"
                    elsif preview.length <= 3
                      preview.inspect
                    else
                      (preview.take(3) << "...").inspect
                    end

          q.text preview
          q.text " at line #{@line}, column #{@column}, offset #{@offset}"
        end
      end

    private

      # @return [DelegatedInput]
      def copy(changes = {})
        DelegatedInput.new \
          changes.fetch(:delegate, @delegate),
          changes.fetch(:offset, @offset),
          changes.fetch(:line, @line),
          changes.fetch(:column, @column)
      end
    end

  end
end

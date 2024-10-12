# frozen_string_literal: true

module Zaid
  module Nodes
    class BreakNode
      def eval(_context)
        raise BreakException
      end

      def ==(other)
        other.is_a?(BreakNode)
      end
    end

    class BreakException < StandardError; end
  end
end

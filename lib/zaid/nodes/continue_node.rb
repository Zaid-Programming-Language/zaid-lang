# frozen_string_literal: true

module Zaid
  module Nodes
    class ContinueNode
      def eval(_context)
        raise ContinueException
      end

      def ==(other)
        other.is_a?(ContinueNode)
      end
    end

    class ContinueException < StandardError; end
  end
end

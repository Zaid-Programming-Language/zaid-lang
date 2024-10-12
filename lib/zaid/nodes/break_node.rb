# frozen_string_literal: true

module Zaid
  module Nodes
    BreakNode = Struct.new do
      def eval(_context)
        raise BreakException
      end
    end

    class BreakException < StandardError; end
  end
end

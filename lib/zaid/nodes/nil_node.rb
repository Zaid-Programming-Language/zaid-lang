# frozen_string_literal: true

require_relative 'literal_node'

module Zaid
  module Nodes
    class NilNode < LiteralNode
      def initialize
        super(nil)
      end

      def eval(_context)
        Constants['مجهول']
      end
    end
  end
end

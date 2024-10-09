# frozen_string_literal: true

require_relative 'literal_node'

module Zaid
  module Nodes
    class TrueNode < LiteralNode
      def initialize
        super(true)
      end

      def eval(_context)
        Constants['صحيح']
      end
    end
  end
end

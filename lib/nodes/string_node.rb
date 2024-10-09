# frozen_string_literal: true

require_relative 'literal_node'

module Zaid
  module Nodes
    class StringNode < LiteralNode
      def eval(_context)
        Constants['النص'].new_with_value(value)
      end
    end
  end
end

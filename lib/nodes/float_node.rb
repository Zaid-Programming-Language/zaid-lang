# frozen_string_literal: true

require_relative 'literal_node'

module Zaid
  module Nodes
    class FloatNode < LiteralNode
      def eval(_context)
        Constants['عدد_عشري'].new_with_value(value)
      end
    end
  end
end

# frozen_string_literal: true

require_relative 'literal_node'

module Zaid
  module Nodes
    class FalseNode < LiteralNode
      def initialize
        super(false)
      end
    end
  end
end

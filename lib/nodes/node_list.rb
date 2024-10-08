# frozen_string_literal: true

module Zaid
  module Nodes
    NodeList = Struct.new(:node_list) do
      def <<(node)
        node_list << node
        self
      end
    end
  end
end

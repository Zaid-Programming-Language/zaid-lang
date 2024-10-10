# frozen_string_literal: true

module Zaid
  module Nodes
    NodeList = Struct.new(:node_list) do
      def <<(node)
        node_list << node

        self
      end

      def eval(context)
        return_value = nil

        node_list.each do |node|
          return_value = node.eval(context)
        end

        return_value || Constants['مجهول']
      end
    end
  end
end

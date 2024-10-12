# frozen_string_literal: true

module Zaid
  module Nodes
    ArrayNode = Struct.new(:elements) do
      def eval(context)
        Constants['مصفوفة'].new_with_value(elements.map { |element| element.eval(context) })
      end
    end
  end
end

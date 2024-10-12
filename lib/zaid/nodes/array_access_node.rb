# frozen_string_literal: true

module Zaid
  module Nodes
    ArrayAccessNode = Struct.new(:array, :index) do
      def eval(context)
        array_value = array.eval(context)
        index_value = index.eval(context)

        array_value.ruby_value[index_value.ruby_value]
      end
    end
  end
end

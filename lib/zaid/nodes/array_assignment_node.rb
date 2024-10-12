# frozen_string_literal: true

module Zaid
  module Nodes
    ArrayAssignmentNode = Struct.new(:array, :index, :value) do
      def eval(context)
        array_value = array.eval(context)
        index_value = index.eval(context)
        new_value = value.eval(context)

        array_value.ruby_value[index_value.ruby_value] = new_value

        new_value
      end
    end
  end
end

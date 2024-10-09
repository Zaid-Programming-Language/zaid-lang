# frozen_string_literal: true

module Zaid
  module Nodes
    SetConstantNode = Struct.new(:name, :value) do
      def eval(context)
        Constants[name] = value.eval(context)
      end
    end
  end
end

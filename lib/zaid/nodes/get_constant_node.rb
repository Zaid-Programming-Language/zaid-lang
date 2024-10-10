# frozen_string_literal: true

module Zaid
  module Nodes
    GetConstantNode = Struct.new(:name) do
      def eval(_context)
        Constants[name]
      end
    end
  end
end

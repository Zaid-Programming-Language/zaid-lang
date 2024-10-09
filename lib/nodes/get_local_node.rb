# frozen_string_literal: true

module Zaid
  module Nodes
    GetLocalNode = Struct.new(:name) do
      def eval(context)
        if Constants.include?(name)
          Constants[name]
        else
          context.locals[name]
        end
      end
    end
  end
end

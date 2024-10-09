# frozen_string_literal: true

module Zaid
  module Nodes
    SetLocalNode = Struct.new(:name, :value) do
      def eval(context)
        if Constants.key?(name)
          Constants[name] = value.eval(context)
        else
          context.locals[name] = value.eval(context)
        end
      end
    end
  end
end

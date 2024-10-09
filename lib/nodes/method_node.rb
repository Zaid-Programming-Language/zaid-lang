# frozen_string_literal: true

module Zaid
  module Nodes
    MethodNode = Struct.new(:name, :params, :body) do
      def eval(context)
        context.current_class.runtime_methods[name] = Runtime::ZaidMethod.new(params, body)
      end
    end
  end
end

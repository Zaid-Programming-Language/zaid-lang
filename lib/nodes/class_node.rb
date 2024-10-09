# frozen_string_literal: true

module Zaid
  module Nodes
    ClassNode = Struct.new(:name, :body) do
      def eval(_context)
        zaid_class = Constants[name]

        unless zaid_class
          zaid_class = Runtime::ZaidClass.new(Constants['شيء'])
          Constants[name] = zaid_class
        end

        class_context = Runtime::Context.new(zaid_class, zaid_class)
        body.eval(class_context)

        zaid_class
      end
    end
  end
end

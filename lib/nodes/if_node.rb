# frozen_string_literal: true

module Zaid
  module Nodes
    IfNode = Struct.new(:condition, :body, :else_body) do
      def eval(context)
        if condition.eval(context).ruby_value
          body.eval(context)
        elsif else_body
          else_body.eval(context)
        else
          Constants['مجهول']
        end
      end
    end
  end
end

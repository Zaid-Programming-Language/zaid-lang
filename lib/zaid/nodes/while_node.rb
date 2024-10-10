# frozen_string_literal: true

module Zaid
  module Nodes
    WhileNode = Struct.new(:condition, :body) do
      def eval(context)
        body.eval(context) while condition.eval(context).ruby_value

        Constants['مجهول']
      end
    end
  end
end

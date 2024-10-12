# frozen_string_literal: true

module Zaid
  module Nodes
    WhileNode = Struct.new(:condition, :body) do
      def eval(context)
        while condition.eval(context).ruby_value
          begin
            body.eval(context)
          rescue BreakException
            break
          rescue ContinueException
            next
          end
        end

        Constants['مجهول']
      end
    end
  end
end

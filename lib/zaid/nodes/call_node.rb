# frozen_string_literal: true

module Zaid
  module Nodes
    CallNode = Struct.new(:receiver, :method_name, :arguments) do
      def eval(context)
        value = if receiver
                  receiver.eval(context)
                else
                  context.current_self
                end

        value.call(method_name, arguments.map { |argument| argument.eval(context) })
      end
    end
  end
end

# frozen_string_literal: true

module Zaid
  module Runtime
    class ZaidObject
      attr_accessor :runtime_class, :ruby_value

      def initialize(runtime_class, ruby_value = self)
        @runtime_class = runtime_class
        @ruby_value = ruby_value
      end

      def call(method_name, arguments = [])
        @runtime_class.lookup(method_name).call(self, arguments)
      end
    end
  end
end

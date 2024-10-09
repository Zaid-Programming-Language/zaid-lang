# frozen_string_literal: true

require_relative './zaid_object'

module Zaid
  module Runtime
    class ZaidClass < ZaidObject
      attr_reader :runtime_methods

      def initialize(superclass = nil)
        @runtime_methods = {}
        @runtime_superclass = superclass
        @runtime_class = Constants['نوع']
      end

      def lookup(method_name)
        method = @runtime_methods[method_name]

        unless method
          return @runtime_superclass.lookup(method_name) if @runtime_superclass

          raise "الدالة `#{method_name}` غير موجودة."
        end

        method
      end

      def def(method_name, &block)
        @runtime_methods[method_name.to_s] = block
      end

      def new
        ZaidObject.new(self)
      end

      def new_with_value(value)
        ZaidObject.new(self, value)
      end
    end
  end
end

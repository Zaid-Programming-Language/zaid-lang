# frozen_string_literal: true

module Zaid
  module Runtime
    class Context
      attr_reader :locals, :current_self, :current_class

      def initialize(current_self, current_class = current_self.runtime_class)
        @locals = {}
        @current_self = current_self
        @current_class = current_class
      end
    end
  end
end

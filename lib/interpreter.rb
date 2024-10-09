# frozen_string_literal: true

require_relative './parser'
require_relative './runtime'

module Zaid
  class Interpreter
    def initialize
      @parser = Parser.new
    end

    def eval(code)
      @parser.parse(code).eval(RootContext)
    end
  end
end

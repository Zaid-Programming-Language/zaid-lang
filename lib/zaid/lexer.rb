# frozen_string_literal: true

require_relative 'lexer_components/tokenizer'
require_relative 'lexer_components/compressor'

module Zaid
  class Lexer
    include LexerComponents

    def initialize
      @tokenizer = Tokenizer.new
      @compressor = Compressor.new
    end

    def tokenize(code, run_compression: true)
      @tokenizer.tokenize(code, run_compression: run_compression)
    end

    def compress(tokens)
      @compressor.compress(tokens)
    end
  end
end

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
      tokens = @tokenizer.tokenize(code, run_compression:)
      tokens = @compressor.compress(tokens) if run_compression
      tokens
    end

    def compress(tokens)
      @compressor.compress(tokens)
    end
  end
end

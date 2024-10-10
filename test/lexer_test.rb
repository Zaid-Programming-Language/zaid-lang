# frozen_string_literal: true

require 'minitest/autorun'

require 'zaid/lexer'

module Zaid
  class LexerTest < Minitest::Test
    include Keywords

    def setup
      @lexer = Lexer.new
    end

    def test_tokenize
      assert_equal [[:IDENTIFIER, 'عدد'], ['=', '='], [:NUMBER, 5]], @lexer.tokenize('عدد = ٥')
    end

    def test_tokenize_without_compression
      code = <<~CODE
        إذا كان ٥ أكبر من ٣ إذن
          اطبع("٥ أكبر من ٣")
      CODE

      tokens = [
        [:IF, IF], [:WAS, WAS], [:NUMBER, 5], [:GREATER, GREATER], [:THAN, THAN], [:NUMBER, 3], [:THEN, THEN],
        [:INDENT, 2],
        [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, '٥ أكبر من ٣'], [')', ')'],
        [:DEDENT, 0]
      ]

      assert_equal tokens, @lexer.tokenize(code, run_compression: false)
    end

    def test_tokenize_with_compression
      code = <<~CODE
        إذا كان ٥ أكبر من ٣ إذن
          اطبع("٥ أكبر من ٣")
      CODE

      tokens = [
        [:IF, "#{IF} #{WAS}"], [:NUMBER, 5], ['>', '>'], [:NUMBER, 3], [:THEN, THEN],
        [:INDENT, 2],
        [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, '٥ أكبر من ٣'], [')', ')'],
        [:DEDENT, 0]
      ]

      assert_equal tokens, @lexer.tokenize(code, run_compression: true)
    end

    def test_compress
      tokens = [
        [:IF, IF], [:WAS, WAS], [:NUMBER, 5], [:GREATER, GREATER], [:THAN, THAN], [:NUMBER, 3], [:THEN, THEN],
        [:INDENT, 2],
        [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, '٥ أكبر من ٣'], [')', ')'],
        [:DEDENT, 0],
        [:ELSE, ELSE],
        [:INDENT, 2],
        [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, '٥ أصغر من أو يساوي ٣'], [')', ')'],
        [:DEDENT, 0]
      ]

      compressed = [
        [:IF, "#{IF} #{WAS}"], [:NUMBER, 5], ['>', '>'], [:NUMBER, 3], [:THEN, THEN],
        [:INDENT, 2],
        [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, '٥ أكبر من ٣'], [')', ')'],
        [:DEDENT, 0],
        [:ELSE, ELSE],
        [:INDENT, 2],
        [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, '٥ أصغر من أو يساوي ٣'], [')', ')'],
        [:DEDENT, 0]
      ]

      assert_equal compressed, @lexer.compress(tokens)
    end
  end
end

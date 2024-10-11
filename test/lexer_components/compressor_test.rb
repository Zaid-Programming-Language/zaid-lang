# frozen_string_literal: true

require 'minitest/autorun'

require 'zaid/lexer_components/compressor'

module Zaid
  module LexerComponents
    class CompressorTest < Minitest::Test
      include Keywords

      def setup
        @compressor = Compressor.new
      end

      def test_compress_if
        tokens = [
          [:IF, IF], [:WAS, WAS], [:NUMBER, 5], [:GREATER, GREATER], [:THAN, THAN], [:NUMBER, 3], [:THEN, THEN],
          [:INDENT, 2],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, '٥ أكبر من ٣'], [')', ')'],
          [:DEDENT, 0],
          [:ELSE_IF, ELSE_IF], [:WAS, WAS], [:NUMBER, 5], [:LESS, LESS], [:THAN, THAN], [:NUMBER, 3], [:THEN, THEN],
          [:INDENT, 2],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, '٥ أصغر من ٣'], [')', ')'],
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
          [:ELSE_IF, "#{ELSE_IF} #{WAS}"], [:NUMBER, 5], ['<', '<'], [:NUMBER, 3], [:THEN, THEN],
          [:INDENT, 2],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, '٥ أصغر من ٣'], [')', ')'],
          [:DEDENT, 0],
          [:ELSE, ELSE],
          [:INDENT, 2],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, '٥ أصغر من أو يساوي ٣'], [')', ')'],
          [:DEDENT, 0]
        ]

        assert_equal compressed, @compressor.compress(tokens)
      end

      def test_compress_while
        tokens = [
          [:IDENTIFIER, 'عدد'], ['=', '='], [:NUMBER, 5],
          [:NEWLINE, "\n"],
          [:WHILE, WHILE], [:WAS, WAS], [:IDENTIFIER, 'عدد'], [:GREATER, GREATER], [:THAN, THAN], [:NUMBER, 0], [:THEN, THEN],
          [:INDENT, 2],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:IDENTIFIER, 'عدد'], [')', ')'],
          [:NEWLINE, "\n"],
          [:IDENTIFIER, 'عدد'], ['=', '='], [:IDENTIFIER, 'عدد'], ['-', '-'], [:NUMBER, 1],
          [:DEDENT, 0]
        ]

        compressed = [
          [:IDENTIFIER, 'عدد'], ['=', '='], [:NUMBER, 5],
          [:NEWLINE, "\n"],
          [:WHILE, "#{WHILE} #{WAS}"], [:IDENTIFIER, 'عدد'], ['>', '>'], [:NUMBER, 0], [:THEN, THEN],
          [:INDENT, 2],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:IDENTIFIER, 'عدد'], [')', ')'],
          [:NEWLINE, "\n"],
          [:IDENTIFIER, 'عدد'], ['=', '='], [:IDENTIFIER, 'عدد'], ['-', '-'], [:NUMBER, 1],
          [:DEDENT, 0]
        ]

        assert_equal compressed, @compressor.compress(tokens)
      end

      def test_compress_greater_than
        tokens = [[:NUMBER, 5], [:GREATER, GREATER], [:THAN, THAN], [:NUMBER, 3]]
        compressed = [[:NUMBER, 5], ['>', '>'], [:NUMBER, 3]]

        assert_equal compressed, @compressor.compress(tokens)
      end

      def test_compress_greater_than_or_equals
        tokens = [[:NUMBER, 5], [:GREATER, GREATER], [:THAN, THAN], [:OR, OR], [:EQUALS, EQUALS], [:NUMBER, 3]]
        compressed = [[:NUMBER, 5], ['>=', '>='], [:NUMBER, 3]]

        assert_equal compressed, @compressor.compress(tokens)
      end

      def test_compress_less_than
        tokens = [[:NUMBER, 5], [:LESS, LESS], [:THAN, THAN], [:NUMBER, 3]]
        compressed = [[:NUMBER, 5], ['<', '<'], [:NUMBER, 3]]

        assert_equal compressed, @compressor.compress(tokens)
      end

      def test_compress_less_than_or_equals
        tokens = [[:NUMBER, 5], [:LESS, LESS], [:THAN, THAN], [:OR, OR], [:EQUALS, EQUALS], [:NUMBER, 3]]
        compressed = [[:NUMBER, 5], ['<=', '<='], [:NUMBER, 3]]

        assert_equal compressed, @compressor.compress(tokens)
      end

      def test_compress_equals
        tokens = [[:NUMBER, 5], [:EQUALS, EQUALS], [:NUMBER, 3]]
        compressed = [[:NUMBER, 5], ['==', '=='], [:NUMBER, 3]]

        assert_equal compressed, @compressor.compress(tokens)
      end

      def test_compress_not_equals
        tokens = [[:NUMBER, 5], [:NOT, NOT], [:EQUALS, EQUALS], [:NUMBER, 3]]
        compressed = [[:NUMBER, 5], ['!=', '!='], [:NUMBER, 3]]

        assert_equal compressed, @compressor.compress(tokens)
      end

      def test_compress_or
        tokens = [[:TRUE, TRUE], [:OR, OR], [:FALSE, FALSE]]
        compressed = [[:TRUE, TRUE], ['||', '||'], [:FALSE, FALSE]]

        assert_equal compressed, @compressor.compress(tokens)
      end

      def test_compress_and
        tokens = [[:TRUE, TRUE], [:AND, AND], [:FALSE, FALSE]]
        compressed = [[:TRUE, TRUE], ['&&', '&&'], [:FALSE, FALSE]]

        assert_equal compressed, @compressor.compress(tokens)
      end

      def test_compress_and_between_receive_and_then
        tokens = [
          [:METHOD, METHOD], [:IDENTIFIER, 'تجربة'], [:RECEIVE, RECEIVE],
          [:IDENTIFIER, 'المتغير_الأول'], [:AND, AND], [:IDENTIFIER, 'المتغير_الثاني'],
          [:THEN, THEN]
        ]

        assert_equal tokens, @compressor.compress(tokens)
      end

      def test_compress_arabic_arithmetic_operator
        tokens = [
          [:PLUS, PLUS],
          [:MINUS, MINUS],
          [:TIMES, TIMES],
          [:DIVIDE, DIVIDE]
        ]

        compressed = [
          ['+', '+'],
          ['-', '-'],
          ['*', '*'],
          ['/', '/']
        ]

        assert_equal compressed, @compressor.compress(tokens)
      end
    end
  end
end

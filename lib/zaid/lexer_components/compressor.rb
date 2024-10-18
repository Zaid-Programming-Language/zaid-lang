# frozen_string_literal: true

require_relative '../keywords'

module Zaid
  module LexerComponents
    class Compressor
      include Keywords

      KEYWORDS_TO_REMOVE_NEWLINES_BEFORE = [[:ELSE, ELSE], [:ELSE_IF, "#{ELSE_IF} #{WAS}"]].freeze

      def compress(tokens)
        compressed = []
        between_receive_and_then = false

        compression_position = 0
        while compression_position < tokens.length
          case tokens[compression_position]
          when [:RECEIVE, RECEIVE]
            between_receive_and_then = true

            compressed << tokens[compression_position]

            compression_position += 1
          when [:IT_IS, IT_IS]
            between_receive_and_then = false

            compressed << tokens[compression_position]

            compression_position += 1
          when [:IF, IF]
            compression_position += compress_if(tokens, compressed, compression_position)
          when [:ELSE_IF, ELSE_IF]
            compression_position += compress_else_if(tokens, compressed, compression_position)
          when [:WHILE, WHILE]
            compression_position += compress_while(tokens, compressed, compression_position)
          when [:GREATER, GREATER]
            compression_position += compress_greater_than_or_equals(tokens, compressed, compression_position)
          when [:LESS, LESS]
            compression_position += compress_less_than_or_equals(tokens, compressed, compression_position)
          when [:EQUALS, EQUALS]
            compression_position += compress_equals(compressed)
          when [:NOT, NOT]
            compression_position += compress_not_equals(tokens, compressed, compression_position)
          when [:OR, OR]
            compression_position += compress_or(compressed)
          when [:AND, AND]
            compression_position += compress_and(tokens, compressed, compression_position, between_receive_and_then)
          when [:PLUS, PLUS], [:MINUS, MINUS], [:TIMES, TIMES], [:DIVIDE, DIVIDE]
            compression_position += compress_arabic_arithmetic_operator(tokens[compression_position], compressed)
          when [:MODULO1, MODULO1], [:MODULO2, MODULO2]
            compression_position += compress_modulo(tokens, compressed, compression_position)
          when [:ZERO, ZERO], [:ONE, ONE]
            compression_position += compress_zero_or_one(tokens[compression_position], compressed)
          else
            compressed << tokens[compression_position]

            compression_position += 1
          end
        end

        remove_newlines_before(compressed, KEYWORDS_TO_REMOVE_NEWLINES_BEFORE)
      end

      private

      # Comverts [[:IF, IF], [:WAS, WAS]] to [:IF, "#{IF} #{WAS}"].
      def compress_if(tokens, compressed, compression_position)
        compressed << [:IF, "#{IF} #{WAS}"]

        if compression_position + 1 < tokens.length && tokens[compression_position + 1] == [:WAS, WAS]
          2
        else
          1
        end
      end

      # Comverts [[:ELSE_IF, ELSE_IF], [:WAS, WAS]] to [:ELSE_IF, "#{ELSE_IF} #{WAS}"].
      def compress_else_if(tokens, compressed, compression_position)
        compressed << [:ELSE_IF, "#{ELSE_IF} #{WAS}"]

        if compression_position + 1 < tokens.length && tokens[compression_position + 1] == [:WAS, WAS]
          2
        else
          1
        end
      end

      # Comverts [[:WHILE, WHILE], [:WAS, WAS]] to [:WHILE, "#{WHILE} #{WAS}"].
      def compress_while(tokens, compressed, compression_position)
        compressed << [:WHILE, "#{WHILE} #{WAS}"]

        if compression_position + 1 < tokens.length && tokens[compression_position + 1] == [:WAS, WAS]
          2
        else
          1
        end
      end

      # Converts:
      #   [[:GREATER, GREATER], [:THAN, THAN], [:OR, OR], [:EQUALS, EQUALS]] to ['>=', '>=']
      #   [[:GREATER, GREATER], [:THAN, THAN]] to ['>', '>']
      def compress_greater_than_or_equals(tokens, compressed, compression_position)
        if compression_position + 1 < tokens.length && tokens[compression_position + 1] == [:THAN, THAN]
          if compression_position + 3 < tokens.length &&
             tokens[compression_position + 2] == [:OR, OR] && tokens[compression_position + 3] == [:EQUALS, EQUALS]
            compressed << ['>=', '>=']

            4
          else
            compressed << ['>', '>']

            2
          end
        else
          compressed << ['>', '>']

          1
        end
      end

      # Converts:
      #   [[:LESS, LESS], [:THAN, THAN], [:OR, OR], [:EQUALS, EQUALS]] to ['<=', '<=']
      #   [[:LESS, LESS], [:THAN, THAN]] to ['<', '<']
      def compress_less_than_or_equals(tokens, compressed, compression_position)
        if compression_position + 1 < tokens.length && tokens[compression_position + 1] == [:THAN, THAN]
          if compression_position + 3 < tokens.length &&
             tokens[compression_position + 2] == [:OR, OR] && tokens[compression_position + 3] == [:EQUALS, EQUALS]
            compressed << ['<=', '<=']

            4
          else
            compressed << ['<', '<']

            2
          end
        else
          compressed << ['<', '<']

          1
        end
      end

      # Converts [:EQUALS, EQUALS] to ['==', '=='].
      def compress_equals(compressed)
        compressed << ['==', '==']

        1
      end

      # Converts [[:NOT, NOT], [:EQUALS, EQUALS]] to ['!=', '!='].
      def compress_not_equals(tokens, compressed, compression_position)
        compressed << ['!=', '!=']

        if compression_position + 1 < tokens.length && tokens[compression_position + 1] == [:EQUALS, EQUALS]
          2
        else
          1
        end
      end

      # Converts [:OR, OR] to ['||', '||'].
      def compress_or(compressed)
        compressed << ['||', '||']

        1
      end

      # Converts [:AND, AND] to ['&&', '&&'], except between [:RECEIVE, RECEIVE] and [:THEN, THEN] tokens.
      def compress_and(tokens, compressed, compression_position, between_receive_and_then)
        compressed << if between_receive_and_then
                        tokens[compression_position]
                      else
                        ['&&', '&&']
                      end

        1
      end

      # Converts:
      #   [:PLUS, PLUS] to ['+', '+']
      #   [:MINUS, MINUS] to ['-', '-']
      #   [:TIMES, TIMES] to ['*', '*']
      #   [:DIVIDE, DIVIDE] to ['/', '/']
      def compress_arabic_arithmetic_operator(token, compressed)
        case token
        when [:PLUS, PLUS]
          compressed << ['+', '+']
        when [:MINUS, MINUS]
          compressed << ['-', '-']
        when [:TIMES, TIMES]
          compressed << ['*', '*']
        when [:DIVIDE, DIVIDE]
          compressed << ['/', '/']
        end

        1
      end

      # Converts [[:MODULO1, MODULO1], [:MODULO2, MODULO2]] to ['%', '%'].
      def compress_modulo(tokens, compressed, compression_position)
        compressed << ['%', '%']

        if compression_position + 1 < tokens.length && tokens[compression_position + 1] == [:MODULO2, MODULO2]
          2
        else
          1
        end
      end

      # Converts:
      #   [:ZERO, ZERO] to [:NUMBER, 0]
      #   [:ONE, ONE] to [:NUMBER, 1]
      def compress_zero_or_one(token, compressed)
        case token
        when [:ZERO, ZERO]
          compressed << [:NUMBER, 0]
        when [:ONE, ONE]
          compressed << [:NUMBER, 1]
        end

        1
      end

      def remove_newlines_before(compressed, keywords)
        compressed.each_with_index.reduce([]) do |result, (token, _index)|
          (result.pop while result.last == [:NEWLINE, "\n"]) if keywords.include?(token)

          result << token
        end
      end
    end
  end
end

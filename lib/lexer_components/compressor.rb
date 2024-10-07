# frozen_string_literal: true

require_relative '../keywords'

module Zaid
  module LexerComponents
    class Compressor
      include Keywords

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
          when [:THEN, THEN]
            between_receive_and_then = false

            compressed << tokens[compression_position]

            compression_position += 1
          when [:IF, IF]
            compression_position += compress_if(tokens, compressed, compression_position)
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
          else
            compressed << tokens[compression_position]

            compression_position += 1
          end
        end

        compressed
      end

      private

      # Comverts [[:IF, IF], [:WAS, WAS]] to [:IF, "#{IF} #{WAS}"].
      def compress_if(tokens, compressed, compression_position)
        if compression_position + 1 < tokens.length && tokens[compression_position + 1] == [:WAS, WAS]
          compressed << [:IF, "#{IF} #{WAS}"]

          2
        else
          compressed << tokens[compression_position]

          1
        end
      end

      # Comverts [[:WHILE, WHILE], [:WAS, WAS]] to [:WHILE, "#{WHILE} #{WAS}"].
      def compress_while(tokens, compressed, compression_position)
        if compression_position + 1 < tokens.length && tokens[compression_position + 1] == [:WAS, WAS]
          compressed << [:WHILE, "#{WHILE} #{WAS}"]

          2
        else
          compressed << tokens[compression_position]

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
          compressed << tokens[compression_position]

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
          compressed << tokens[compression_position]

          1
        end
      end

      # Converts [[:EQUALS, EQUALS]] to ['==', '=='].
      def compress_equals(compressed)
        compressed << ['==', '==']

        1
      end

      # Converts [[:NOT, NOT], [:EQUALS, EQUALS]] to ['!=', '!='].
      def compress_not_equals(tokens, compressed, compression_position)
        if compression_position + 1 < tokens.length && tokens[compression_position + 1] == [:EQUALS, EQUALS]
          compressed << ['!=', '!=']

          2
        else
          compressed << tokens[compression_position]

          1
        end
      end

      # Converts [[:OR, OR]] to ['||', '||'].
      def compress_or(compressed)
        compressed << ['||', '||']

        1
      end

      # Converts [[:AND, AND]] to ['&&', '&&'], except between [:RECEIVE, RECEIVE] and [:THEN, THEN] tokens.
      def compress_and(tokens, compressed, compression_position, between_receive_and_then)
        compressed << if between_receive_and_then
                        tokens[compression_position]
                      else
                        ['&&', '&&']
                      end

        1
      end
    end
  end
end

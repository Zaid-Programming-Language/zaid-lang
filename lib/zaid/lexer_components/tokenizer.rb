# frozen_string_literal: true

require 'strscan'

require_relative '../keywords'
require_relative 'compressor'

module Zaid
  module LexerComponents
    class Tokenizer
      include Keywords

      KEYWORDS_MAPPING = {
        AND => :AND,
        BREAK => :BREAK,
        CLASS => :CLASS,
        CONTINUE => :CONTINUE,
        DIVIDE => :DIVIDE,
        ELSE => :ELSE,
        ELSE_IF => :ELSE_IF,
        EQUALS => :EQUALS,
        FALSE => :FALSE,
        GREATER => :GREATER,
        IF => :IF,
        IS => :IS,
        IT_IS => :IT_IS,
        LESS => :LESS,
        METHOD => :METHOD,
        MINUS => :MINUS,
        MODULO1 => :MODULO1,
        MODULO2 => :MODULO2,
        NIL => :NIL,
        NOT => :NOT,
        ONE => :ONE,
        OR => :OR,
        PLUS => :PLUS,
        RECEIVE => :RECEIVE,
        THAN => :THAN,
        THEN => :THEN,
        TIMES => :TIMES,
        TRUE => :TRUE,
        WAS => :WAS,
        WHILE => :WHILE,
        ZERO => :ZERO
      }.freeze

      COMMENT_PREFIXES = ['#', 'تعليق:', 'ملاحظة:', 'سؤال:'].freeze
      INDENT_KEYWORDS = [THEN, IS, ELSE, IT_IS].freeze
      ARABIC_CHARACTERS = 'ابتةثجحخدذرزسشصضطظعغفقكلمنهوىيءآأؤإئ'
      ARABIC_DIGITS = '٠١٢٣٤٥٦٧٨٩'
      ENGLISH_DIGITS = '0123456789'
      DIGITS = [ARABIC_DIGITS, ENGLISH_DIGITS].join

      TOKEN_PATTERNS = [
        { pattern: /\n *\n/m, type: :empty_line },
        { pattern: /((#{Regexp.union(COMMENT_PREFIXES)}).*$)/, type: :comment },
        { pattern: /([#{ARABIC_CHARACTERS}_ـ][#{ARABIC_CHARACTERS}#{DIGITS}_ـ]*؟?)/, type: :identifier },
        { pattern: /([#{DIGITS}]+\.[#{DIGITS}]+)/, type: :float },
        { pattern: /([#{DIGITS}]+)/, type: :number },
        { pattern: /"([^"]*)"/, type: :string },
        { pattern: /\n( *)/m, type: :dedent },
        { pattern: /(\|\||&&|==|!=|<=|>=|<|>)/, type: :operator },
        { pattern: /(.)/, type: :single_character }
      ].freeze

      INDENT_PATTERN = /\G\n( +)/m

      def tokenize(code, run_compression: true)
        code = StringScanner.new(code.chomp)

        tokens = []
        indent_stack = []
        @array_stack = 0

        parse_token(code, tokens, indent_stack) until code.eos?

        while indent_stack.pop
          tokens << [:DEDENT, indent_stack.last || 0]
          tokens << [:NEWLINE, "\n"]
        end

        run_compression ? Compressor.new.compress(tokens) : tokens
      end

      private

      def parse_token(code, tokens, indent_stack)
        TOKEN_PATTERNS.each do |token|
          next unless code.scan(token[:pattern])

          send(:"parse_#{token[:type]}", code, tokens, indent_stack)

          break if @array_stack.positive?
          break unless INDENT_KEYWORDS.include?(code.captures.first)

          raise 'خطأ في المسافة البادئة للأسطر.' unless code.scan(INDENT_PATTERN)

          parse_indent(code, tokens, indent_stack)

          break
        end
      end

      def parse_empty_line(code, tokens, _)
        tokens << [:NEWLINE, "\n"] && !tokens.empty?

        code.pos -= 1
      end

      def parse_comment(code, tokens, _)
        tokens << [:COMMENT, code.captures.first]
      end

      def parse_identifier(code, tokens, _)
        identifier = code.captures.first

        tokens << if KEYWORDS_MAPPING.key?(identifier)
                    [KEYWORDS_MAPPING[identifier], identifier]
                  elsif tokens.last == [:CLASS, CLASS]
                    [:CONSTANT, identifier]
                  else
                    [:IDENTIFIER, identifier]
                  end
      end

      def parse_float(code, tokens, _)
        tokens << [:FLOAT, code.captures.first.tr(ARABIC_DIGITS, ENGLISH_DIGITS).to_f]
      end

      def parse_number(code, tokens, _)
        tokens << [:NUMBER, code.captures.first.tr(ARABIC_DIGITS, ENGLISH_DIGITS).to_i]
      end

      def parse_string(code, tokens, _)
        tokens << [:STRING, code.captures.first]
      end

      def parse_dedent(code, tokens, indent_stack)
        return if @array_stack.positive?

        indent = code.captures.first.size
        current_indent = indent_stack.last || 0

        raise 'خطأ في المسافة البادئة للأسطر.' if indent > current_indent

        tokens << [:NEWLINE, "\n"] if indent == current_indent && !tokens.empty?

        while indent < (indent_stack.last || 0)
          indent_stack.pop
          tokens << [:DEDENT, indent]
          tokens << [:NEWLINE, "\n"]
        end
      end

      def parse_operator(code, tokens, _)
        tokens << [code.captures.first, code.captures.first]
      end

      def parse_single_character(code, tokens, _)
        token = code.captures.first

        tokens << [token, token] if token != ' '

        @array_stack += 1 if token == '['
        @array_stack -= 1 if token == ']'
      end

      def parse_indent(code, tokens, indent_stack)
        indent = code.captures.first.size

        if indent <= (indent_stack.last || 0)
          raise 'خطأ في المسافة البادئة للأسطر، ' \
                "المسافة البادئة هي #{indent} " \
                "والمسافة البادئة المتوقعة يجب أن تكون أكبر من #{indent_stack.last || 0}"
        end

        indent_stack.push(indent)
        tokens << [:INDENT, indent]
      end
    end
  end
end

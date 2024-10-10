# frozen_string_literal: true

require_relative '../keywords'
require_relative 'compressor'

module Zaid
  module LexerComponents
    class Tokenizer
      include Keywords

      KEYWORDS_MAPPING = {
        AND => :AND,
        CLASS => :CLASS,
        DIVIDE => :DIVIDE,
        ELSE => :ELSE,
        EQUALS => :EQUALS,
        FALSE => :FALSE,
        GREATER => :GREATER,
        IF => :IF,
        IS => :IS,
        IT_IS => :IT_IS,
        LESS => :LESS,
        METHOD => :METHOD,
        MINUS => :MINUS,
        NIL => :NIL,
        NOT => :NOT,
        OR => :OR,
        PLUS => :PLUS,
        RECEIVE => :RECEIVE,
        THAN => :THAN,
        THEN => :THEN,
        TIMES => :TIMES,
        TRUE => :TRUE,
        WAS => :WAS,
        WHILE => :WHILE
      }.freeze

      COMMENT_PREFIXES = ['#', 'تعليق:', 'ملاحظة:', 'سؤال:'].freeze
      INDENT_KEYWORDS = [THEN, IS, ELSE, IT_IS].freeze
      ARABIC_CHARACTERS = 'ابتةثجحخدذرزسشصضطظعغفقكلمنهوىيءآأؤإئ'
      ARABIC_DIGITS = '٠١٢٣٤٥٦٧٨٩'
      ENGLISH_DIGITS = '0123456789'
      DIGITS = [ARABIC_DIGITS, ENGLISH_DIGITS].join

      TOKEN_PATTERNS = [
        { pattern: /\G((#{Regexp.union(COMMENT_PREFIXES)}).*$)/, type: :comment },
        { pattern: /\G([#{ARABIC_CHARACTERS}_ـ][#{ARABIC_CHARACTERS}#{DIGITS}_ـ]*؟?)/, type: :identifier },
        { pattern: /\G([#{DIGITS}]+\.[#{DIGITS}]+)/, type: :float },
        { pattern: /\G([#{DIGITS}]+)/, type: :number },
        { pattern: /\G"([^"]*)"/, type: :string },
        { pattern: /\G\n( *)/m, type: :dedent },
        { pattern: /\G(\|\||&&|==|!=|<=|>=|<|>)/, type: :operator },
        { pattern: /\G(.)/, type: :single_character }
      ].freeze

      INDENT_PATTERN = /\G\n( +)/m

      def tokenize(code, run_compression: true)
        code = code.chomp

        tokens = []
        indent_stack = []

        parsing_position = 0
        parsing_position += parse_token(code, tokens, indent_stack, parsing_position) while parsing_position < code.size

        tokens << [:DEDENT, indent_stack.last || 0] while indent_stack.pop

        run_compression ? Compressor.new.compress(tokens) : tokens
      end

      private

      def parse_token(code, tokens, indent_stack, parsing_position)
        TOKEN_PATTERNS.each do |token|
          match = code.match(token[:pattern], parsing_position)

          next unless match

          position_increase = send(:"parse_#{token[:type]}", match[1], tokens, indent_stack)

          return position_increase unless INDENT_KEYWORDS.include?(match[1])

          match = code.match(INDENT_PATTERN, parsing_position + position_increase)

          raise 'خطأ في المسافة البادئة للأسطر.' unless match

          return parse_indent(match[1], tokens, indent_stack) + position_increase
        end
      end

      def parse_comment(comment, tokens, _)
        tokens << [:COMMENT, comment]

        comment.size
      end

      def parse_identifier(identifier, tokens, _)
        if identifier.end_with?('؟') && (tokens.empty? || ![[:METHOD, METHOD], ['.', '.']].include?(tokens.last))
          raise 'خطأ: لا يمكن استخدام "؟" في اسم المعرف إلا بعد كلمة "دالة" أو بعد نقطة.'
        end

        tokens << if KEYWORDS_MAPPING.key?(identifier)
                    [KEYWORDS_MAPPING[identifier], identifier]
                  elsif tokens.last == [:CLASS, CLASS]
                    [:CONSTANT, identifier]
                  else
                    [:IDENTIFIER, identifier]
                  end

        identifier.size
      end

      def parse_float(float, tokens, _)
        tokens << [:FLOAT, float.tr(ARABIC_DIGITS, ENGLISH_DIGITS).to_f]

        float.size
      end

      def parse_number(number, tokens, _)
        tokens << [:NUMBER, number.tr(ARABIC_DIGITS, ENGLISH_DIGITS).to_i]

        number.size
      end

      def parse_string(string, tokens, _)
        tokens << [:STRING, string]

        string.size + 2
      end

      def parse_dedent(indent, tokens, indent_stack)
        current_indent = indent_stack.last || 0

        raise 'خطأ في المسافة البادئة للأسطر.' if indent.size > current_indent

        tokens << [:NEWLINE, "\n"] if indent.size == current_indent

        if indent.size < current_indent
          while indent.size < (indent_stack.last || 0)
            indent_stack.pop
            tokens << [:DEDENT, indent.size]
          end
        end

        indent.size + 1
      end

      def parse_operator(operator, tokens, _)
        tokens << [operator, operator]

        operator.size
      end

      def parse_single_character(character, tokens, _)
        tokens << [character, character] if character != ' '

        1
      end

      def parse_indent(indent, tokens, indent_stack)
        if indent.size <= (indent_stack.last || 0)
          raise 'خطأ في المسافة البادئة للأسطر، ' \
                "المسافة البادئة هي #{indent.size} " \
                "والمسافة البادئة المتوقعة يجب أن تكون أكبر من #{indent_stack.last || 0}"
        end

        indent_stack.push(indent.size)
        tokens << [:INDENT, indent.size]

        indent.size + 1
      end
    end
  end
end

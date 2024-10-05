# frozen_string_literal: true

module Zaid
  class Lexer
    LESS    = 'أصغر'
    GREATER = 'أكبر'
    OR      = 'أو'
    IF      = 'إذا'
    THEN    = 'إذن'
    RECEIVE = 'تستقبل'
    FALSE   = 'خاطئ'
    METHOD  = 'دالة'
    TRUE    = 'صحيح'
    WHILE   = 'طالما'
    WAS     = 'كان'
    NOT     = 'لا'
    NIL     = 'مجهول'
    THAN    = 'من'
    CLASS   = 'نوع'
    IS      = 'هو'
    AND     = 'و'
    ELSE    = 'وإلا'
    IT_IS   = 'وهي'
    EQUALS  = 'يساوي'

    KEYWORDS_MAPPING = {
      LESS => :LESS,
      GREATER => :GREATER,
      OR => :OR,
      IF => :IF,
      THEN => :THEN,
      RECEIVE => :RECEIVE,
      FALSE => :FALSE,
      METHOD => :METHOD,
      TRUE => :TRUE,
      WHILE => :WHILE,
      WAS => :WAS,
      NOT => :NOT,
      NIL => :NIL,
      THAN => :THAN,
      CLASS => :CLASS,
      IS => :IS,
      AND => :AND,
      ELSE => :ELSE,
      IT_IS => :IT_IS,
      EQUALS => :EQUALS
    }.freeze

    INDENT_KEYWORDS = [THEN, IS, ELSE, IT_IS].freeze
    ARABIC_CHARACTERS = 'ابتةثجحخدذرزسشصضطظعغفقكلمنهوىيءآأؤإئ'
    ARABIC_DIGITS = '٠١٢٣٤٥٦٧٨٩'
    ENGLISH_DIGITS = '0123456789'
    DIGITS = [ARABIC_DIGITS, ENGLISH_DIGITS].join

    TOKEN_PATTERNS = [
      { pattern: /\G(#.*$)/, type: :comment },
      { pattern: /\G([#{ARABIC_CHARACTERS}_ـ][#{ARABIC_CHARACTERS}#{DIGITS}_ـ]*)/, type: :identifier },
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

      run_compression ? compress(tokens) : tokens
    end

    def compress(tokens)
      compressed = []
      between_receive_and_then = false

      compression_position = 0
      while compression_position < tokens.length
        case tokens[compression_position]
        when [:RECEIVE, 'تستقبل'], [:THEN, 'إذن']
          between_receive_and_then = !between_receive_and_then

          compressed << tokens[compression_position]

          compression_position += 1
        when [:IF, 'إذا']
          compression_position += compress_if(tokens, compressed, compression_position)
        when [:WHILE, 'طالما']
          compression_position += compress_while(tokens, compressed, compression_position)
        when [:GREATER, 'أكبر']
          compression_position += compress_greater_than_or_equals(tokens, compressed, compression_position)
        when [:LESS, 'أصغر']
          compression_position += compress_less_than_or_equals(tokens, compressed, compression_position)
        when [:EQUALS, 'يساوي']
          compression_position += compress_equals(compressed)
        when [:NOT, 'لا']
          compression_position += compress_not_equals(tokens, compressed, compression_position)
        when [:OR, 'أو']
          compression_position += compress_or(compressed)
        when [:AND, 'و']
          compression_position += compress_and(tokens, compressed, compression_position, between_receive_and_then)
        else
          compressed << tokens[compression_position]

          compression_position += 1
        end
      end

      compressed
    end

    private

    # Tokenization.

    def parse_token(code, tokens, indent_stack, parsing_position)
      TOKEN_PATTERNS.each do |token|
        match = code.match(token[:pattern], parsing_position)

        next unless match

        position_increase = send("parse_#{token[:type]}", match[1], tokens, indent_stack)

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
      tokens << if KEYWORDS_MAPPING.keys.include?(identifier)
                  [KEYWORDS_MAPPING[identifier], identifier]
                elsif tokens[tokens.length - 1] == [:CLASS, 'نوع']
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

    # Compression.

    # Comverts [[:IF, 'إذا'], [:WAS, 'كان']] to [:IF, 'إذا كان'].
    def compress_if(tokens, compressed, compression_position)
      if compression_position + 1 < tokens.length && tokens[compression_position + 1] == [:WAS, 'كان']
        compressed << [:IF, 'إذا كان']

        2
      else
        compressed << tokens[compression_position]

        1
      end
    end

    # Comverts [[:WHILE, 'طالما'], [:WAS, 'كان']] to [:WHILE, 'طالما كان'].
    def compress_while(tokens, compressed, compression_position)
      if compression_position + 1 < tokens.length && tokens[compression_position + 1] == [:WAS, 'كان']
        compressed << [:WHILE, 'طالما كان']

        2
      else
        compressed << tokens[compression_position]

        1
      end
    end

    # Converts:
    #   [[:GREATER, 'أكبر'], [:THAN, 'من'], [:OR, 'أو'], [:EQUALS, 'يساوي']] to ['>=', '>=']
    #   [[:GREATER, 'أكبر'], [:THAN, 'من']] to ['>', '>']
    def compress_greater_than_or_equals(tokens, compressed, compression_position)
      if compression_position + 1 < tokens.length && tokens[compression_position + 1] == [:THAN, 'من']
        if compression_position + 3 < tokens.length &&
           tokens[compression_position + 2] == [:OR, 'أو'] && tokens[compression_position + 3] == [:EQUALS, 'يساوي']
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
    #   [[:LESS, 'أصغر'], [:THAN, 'من'], [:OR, 'أو'], [:EQUALS, 'يساوي']] to ['<=', '<=']
    #   [[:LESS, 'أصغر'], [:THAN, 'من']] to ['<', '<']
    def compress_less_than_or_equals(tokens, compressed, compression_position)
      if compression_position + 1 < tokens.length && tokens[compression_position + 1] == [:THAN, 'من']
        if compression_position + 3 < tokens.length &&
           tokens[compression_position + 2] == [:OR, 'أو'] && tokens[compression_position + 3] == [:EQUALS, 'يساوي']
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

    # Converts [[:EQUALS, 'يساوي']] to ['==', '=='].
    def compress_equals(compressed)
      compressed << ['==', '==']

      1
    end

    # Converts [[:NOT, 'لا'], [:EQUALS, 'يساوي']] to ['!=', '!='].
    def compress_not_equals(tokens, compressed, compression_position)
      if compression_position + 1 < tokens.length && tokens[compression_position + 1] == [:EQUALS, 'يساوي']
        compressed << ['!=', '!=']

        2
      else
        compressed << tokens[compression_position]

        1
      end
    end

    # Converts [[:OR, 'أو']] to ['||', '||'].
    def compress_or(compressed)
      compressed << ['||', '||']

      1
    end

    # Converts [[:AND, 'و']] to ['&&', '&&'], except between [:RECEIVE, 'تستقبل'] and [:THEN, 'إذن'] tokens.
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

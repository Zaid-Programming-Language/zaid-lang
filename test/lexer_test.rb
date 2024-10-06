# frozen_string_literal: true

require 'minitest/autorun'
require './lexer'

module Zaid
  class LexerTest < Minitest::Test
    # Tokenization.

    def test_comment
      code = <<~CODE
        # هذا تعليق في بداية البرنامج
        عدد = ٥
        # هذا تعليق في وسط البرنامج
        # وهذا تعليق آخر معه
        اطبع(عدد)
        # أخيرا، هذا تعليق في نهاية البرنامج
      CODE

      tokens = [
        [:NEWLINE, "\n"],
        [:IDENTIFIER, 'عدد'],
        ['=', '='],
        [:NUMBER, 5],
        [:NEWLINE, "\n"],
        [:IDENTIFIER, 'اطبع'],
        ['(', '('],
        [:IDENTIFIER, 'عدد'],
        [')', ')'],
        [:NEWLINE, "\n"]
      ]

      assert_equal tokens, Zaid::Lexer.new.tokenize(code)
    end

    def test_identifier
      assert_equal [[:IDENTIFIER, 'عدد']], Zaid::Lexer.new.tokenize('عدد')
    end

    def test_float
      assert_equal [[:FLOAT, 3.14]], Zaid::Lexer.new.tokenize('٣.١٤')
      assert_equal [[:FLOAT, 3.14]], Zaid::Lexer.new.tokenize('3.14')
    end

    def test_number
      assert_equal [[:NUMBER, 314]], Zaid::Lexer.new.tokenize('٣١٤')
      assert_equal [[:NUMBER, 314]], Zaid::Lexer.new.tokenize('314')
    end

    def test_mixed_digits
      assert_equal [[:NUMBER, 314]], Zaid::Lexer.new.tokenize('3١٤')
    end

    def test_string
      assert_equal [[:STRING, 'زيد']], Zaid::Lexer.new.tokenize('"زيد"')
    end

    def test_operator
      assert_equal [['||', '||']], Zaid::Lexer.new.tokenize('||')
      assert_equal [['&&', '&&']], Zaid::Lexer.new.tokenize('&&')
      assert_equal [['==', '==']], Zaid::Lexer.new.tokenize('==')
      assert_equal [['!=', '!=']], Zaid::Lexer.new.tokenize('!=')
      assert_equal [['<=', '<=']], Zaid::Lexer.new.tokenize('<=')
      assert_equal [['>=', '>=']], Zaid::Lexer.new.tokenize('>=')
      assert_equal [['<', '<']], Zaid::Lexer.new.tokenize('<')
      assert_equal [['>', '>']], Zaid::Lexer.new.tokenize('>')

      assert_equal [[:NUMBER, 5], ['>=', '>='], [:NUMBER, 3]], Zaid::Lexer.new.tokenize('5 >=3')
      assert_equal [[:NUMBER, 5], ['>=', '>='], [:NUMBER, 3]], Zaid::Lexer.new.tokenize('5>= 3')
      assert_equal [[:NUMBER, 5], ['>=', '>='], [:NUMBER, 3]], Zaid::Lexer.new.tokenize('5>=3')
    end

    def test_arabic_operators
      assert_equal [[:NUMBER, 5], [:EQUALS, Lexer::EQUALS], [:NUMBER, 3]],
                   Zaid::Lexer.new.tokenize('٥ يساوي ٣', run_compression: false)

      assert_equal [[:NUMBER, 5], [:NOT, Lexer::NOT], [:EQUALS, Lexer::EQUALS], [:NUMBER, 3]],
                   Zaid::Lexer.new.tokenize('٥ لا يساوي ٣', run_compression: false)

      assert_equal [[:NUMBER, 5], [:GREATER, Lexer::GREATER], [:THAN, Lexer::THAN], [:NUMBER, 3]],
                   Zaid::Lexer.new.tokenize('٥ أكبر من ٣', run_compression: false)

      assert_equal [[:NUMBER, 5], [:LESS, Lexer::LESS], [:THAN, Lexer::THAN], [:NUMBER, 3]],
                   Zaid::Lexer.new.tokenize('٥ أصغر من ٣', run_compression: false)

      assert_equal [[:NUMBER, 5], [:GREATER, Lexer::GREATER], [:THAN, Lexer::THAN], [:OR, Lexer::OR], [:EQUALS, Lexer::EQUALS], [:NUMBER, 3]],
                   Zaid::Lexer.new.tokenize('٥ أكبر من أو يساوي ٣', run_compression: false)

      assert_equal [[:NUMBER, 5], [:LESS, Lexer::LESS], [:THAN, Lexer::THAN], [:OR, Lexer::OR], [:EQUALS, Lexer::EQUALS], [:NUMBER, 3]],
                   Zaid::Lexer.new.tokenize('٥ أصغر من أو يساوي ٣', run_compression: false)
    end

    def test_single_character
      assert_equal [['+', '+']], Zaid::Lexer.new.tokenize('+')
      assert_equal [['-', '-']], Zaid::Lexer.new.tokenize('-')
      assert_equal [['*', '*']], Zaid::Lexer.new.tokenize('*')
      assert_equal [['/', '/']], Zaid::Lexer.new.tokenize('/')
      assert_equal [['(', '(']], Zaid::Lexer.new.tokenize('(')
      assert_equal [[')', ')']], Zaid::Lexer.new.tokenize(')')
    end

    def test_if_statement
      code = <<~CODE
        إذا كان ٥ أكبر من ٣ إذن
          اطبع("٥ أكبر من ٣")
      CODE

      tokens = [
        [:IF, Lexer::IF],
        [:WAS, Lexer::WAS],
        [:NUMBER, 5],
        [:GREATER, Lexer::GREATER],
        [:THAN, Lexer::THAN],
        [:NUMBER, 3],
        [:THEN, Lexer::THEN],
        [:INDENT, 2],
        [:IDENTIFIER, 'اطبع'],
        ['(', '('],
        [:STRING, '٥ أكبر من ٣'],
        [')', ')'],
        [:DEDENT, 0]
      ]

      assert_equal tokens, Zaid::Lexer.new.tokenize(code, run_compression: false)
    end

    def test_if_else_statement
      code = <<~CODE
        إذا كان ٥ أكبر من ٣ إذن
          اطبع("٥ أكبر من ٣")
        وإلا
          اطبع("٥ أصغر من أو يساوي ٣")
      CODE

      tokens = [
        [:IF, Lexer::IF],
        [:WAS, Lexer::WAS],
        [:NUMBER, 5],
        [:GREATER, Lexer::GREATER],
        [:THAN, Lexer::THAN],
        [:NUMBER, 3],
        [:THEN, Lexer::THEN],
        [:INDENT, 2],
        [:IDENTIFIER, 'اطبع'],
        ['(', '('],
        [:STRING, '٥ أكبر من ٣'],
        [')', ')'],
        [:DEDENT, 0],
        [:ELSE, Lexer::ELSE],
        [:INDENT, 2],
        [:IDENTIFIER, 'اطبع'],
        ['(', '('],
        [:STRING, '٥ أصغر من أو يساوي ٣'],
        [')', ')'],
        [:DEDENT, 0]
      ]

      assert_equal tokens, Zaid::Lexer.new.tokenize(code, run_compression: false)
    end

    def test_while_statement
      code = <<~CODE
        عدد = ٥
        طالما كان عدد أكبر من ٠ إذن
          اطبع(عدد)
          عدد = عدد - ١
      CODE

      tokens = [
        [:IDENTIFIER, 'عدد'],
        ['=', '='],
        [:NUMBER, 5],
        [:NEWLINE, "\n"],
        [:WHILE, Lexer::WHILE],
        [:WAS, Lexer::WAS],
        [:IDENTIFIER, 'عدد'],
        [:GREATER, Lexer::GREATER],
        [:THAN, Lexer::THAN],
        [:NUMBER, 0],
        [:THEN, Lexer::THEN],
        [:INDENT, 2],
        [:IDENTIFIER, 'اطبع'],
        ['(', '('],
        [:IDENTIFIER, 'عدد'],
        [')', ')'],
        [:NEWLINE, "\n"],
        [:IDENTIFIER, 'عدد'],
        ['=', '='],
        [:IDENTIFIER, 'عدد'],
        ['-', '-'],
        [:NUMBER, 1],
        [:DEDENT, 0]
      ]

      assert_equal tokens, Zaid::Lexer.new.tokenize(code, run_compression: false)
    end

    def test_method
      code = <<~CODE
        دالة جمع_٣_أعداد تستقبل العدد_الأول و العدد_الثاني و العدد_الثالث وهي
          العدد_الأول + العدد_الثاني + العدد_الثالث
      CODE

      tokens = [
        [:METHOD, Lexer::METHOD],
        [:IDENTIFIER, 'جمع_٣_أعداد'],
        [:RECEIVE, Lexer::RECEIVE],
        [:IDENTIFIER, 'العدد_الأول'],
        [:AND, Lexer::AND],
        [:IDENTIFIER, 'العدد_الثاني'],
        [:AND, Lexer::AND],
        [:IDENTIFIER, 'العدد_الثالث'],
        [:IT_IS, Lexer::IT_IS],
        [:INDENT, 2],
        [:IDENTIFIER, 'العدد_الأول'],
        ['+', '+'],
        [:IDENTIFIER, 'العدد_الثاني'],
        ['+', '+'],
        [:IDENTIFIER, 'العدد_الثالث'],
        [:DEDENT, 0]
      ]

      assert_equal tokens, Zaid::Lexer.new.tokenize(code)
    end

    def test_class
      code = <<~CODE
        نوع الحيوانات هو
          دالة المشي وهي
            اطبع("الحيوان يمشي")
      CODE

      tokens = [
        [:CLASS, Lexer::CLASS],
        [:CONSTANT, 'الحيوانات'],
        [:IS, Lexer::IS],
        [:INDENT, 2],
        [:METHOD, Lexer::METHOD],
        [:IDENTIFIER, 'المشي'],
        [:IT_IS, Lexer::IT_IS],
        [:INDENT, 4],
        [:IDENTIFIER, 'اطبع'],
        ['(', '('],
        [:STRING, 'الحيوان يمشي'],
        [')', ')'],
        [:DEDENT, 2],
        [:DEDENT, 0]
      ]

      assert_equal tokens, Zaid::Lexer.new.tokenize(code)
    end

    def test_dedent_error
      code = <<~CODE
        عدد = ٥
          عدد = عدد + ١
      CODE

      error = assert_raises(RuntimeError) do
        Zaid::Lexer.new.tokenize(code)
      end

      assert_equal 'خطأ في المسافة البادئة للأسطر.', error.message
    end

    def test_zero_indent_error
      code = <<~CODE
        دالة تجربة وهي
        اطبع("تجربة")
      CODE

      error = assert_raises(RuntimeError) do
        Zaid::Lexer.new.tokenize(code)
      end

      assert_equal 'خطأ في المسافة البادئة للأسطر.', error.message
    end

    def test_non_zero_indent_error
      code = <<~CODE
        نوع تجربة هو
          دالة تجربة وهي
          اطبع("تجربة")
      CODE

      error = assert_raises(RuntimeError) do
        Zaid::Lexer.new.tokenize(code)
      end

      assert_equal(
        'خطأ في المسافة البادئة للأسطر، المسافة البادئة هي 2 والمسافة البادئة المتوقعة يجب أن تكون أكبر من 2',
        error.message
      )
    end

    # Compression.

    def test_compress_if
      tokens = [
        [:IF, Lexer::IF],
        [:WAS, Lexer::WAS],
        [:NUMBER, 5],
        [:GREATER, Lexer::GREATER],
        [:THAN, Lexer::THAN],
        [:NUMBER, 3],
        [:THEN, Lexer::THEN],
        [:INDENT, 2],
        [:IDENTIFIER, 'اطبع'],
        ['(', '('],
        [:STRING, '٥ أكبر من ٣'],
        [')', ')'],
        [:DEDENT, 0],
        [:ELSE, Lexer::ELSE],
        [:INDENT, 2],
        [:IDENTIFIER, 'اطبع'],
        ['(', '('],
        [:STRING, '٥ أصغر من أو يساوي ٣'],
        [')', ')'],
        [:DEDENT, 0]
      ]

      compressed = [
        [:IF, "#{Lexer::IF} #{Lexer::WAS}"],
        [:NUMBER, 5],
        ['>', '>'],
        [:NUMBER, 3],
        [:THEN, Lexer::THEN],
        [:INDENT, 2],
        [:IDENTIFIER, 'اطبع'],
        ['(', '('],
        [:STRING, '٥ أكبر من ٣'],
        [')', ')'],
        [:DEDENT, 0],
        [:ELSE, Lexer::ELSE],
        [:INDENT, 2],
        [:IDENTIFIER, 'اطبع'],
        ['(', '('],
        [:STRING, '٥ أصغر من أو يساوي ٣'],
        [')', ')'],
        [:DEDENT, 0]
      ]

      assert_equal compressed, Zaid::Lexer.new.compress(tokens)
    end

    def test_compress_while
      tokens = [
        [:IDENTIFIER, 'عدد'],
        ['=', '='],
        [:NUMBER, 5],
        [:NEWLINE, "\n"],
        [:WHILE, Lexer::WHILE],
        [:WAS, Lexer::WAS],
        [:IDENTIFIER, 'عدد'],
        [:GREATER, Lexer::GREATER],
        [:THAN, Lexer::THAN],
        [:NUMBER, 0],
        [:THEN, Lexer::THEN],
        [:INDENT, 2],
        [:IDENTIFIER, 'اطبع'],
        ['(', '('],
        [:IDENTIFIER, 'عدد'],
        [')', ')'],
        [:NEWLINE, "\n"],
        [:IDENTIFIER, 'عدد'],
        ['=', '='],
        [:IDENTIFIER, 'عدد'],
        ['-', '-'],
        [:NUMBER, 1],
        [:DEDENT, 0]
      ]

      compressed = [
        [:IDENTIFIER, 'عدد'],
        ['=', '='],
        [:NUMBER, 5],
        [:NEWLINE, "\n"],
        [:WHILE, "#{Lexer::WHILE} #{Lexer::WAS}"],
        [:IDENTIFIER, 'عدد'],
        ['>', '>'],
        [:NUMBER, 0],
        [:THEN, Lexer::THEN],
        [:INDENT, 2],
        [:IDENTIFIER, 'اطبع'],
        ['(', '('],
        [:IDENTIFIER, 'عدد'],
        [')', ')'],
        [:NEWLINE, "\n"],
        [:IDENTIFIER, 'عدد'],
        ['=', '='],
        [:IDENTIFIER, 'عدد'],
        ['-', '-'],
        [:NUMBER, 1],
        [:DEDENT, 0]
      ]

      assert_equal compressed, Zaid::Lexer.new.compress(tokens)
    end

    def test_compress_greater_than
      tokens = [
        [:NUMBER, 5],
        [:GREATER, Lexer::GREATER],
        [:THAN, Lexer::THAN],
        [:NUMBER, 3]
      ]

      compressed = [
        [:NUMBER, 5],
        ['>', '>'],
        [:NUMBER, 3]
      ]

      assert_equal compressed, Zaid::Lexer.new.compress(tokens)
    end

    def test_compress_greater_than_or_equals
      tokens = [
        [:NUMBER, 5],
        [:GREATER, Lexer::GREATER],
        [:THAN, Lexer::THAN],
        [:OR, Lexer::OR],
        [:EQUALS, Lexer::EQUALS],
        [:NUMBER, 3]
      ]

      compressed = [
        [:NUMBER, 5],
        ['>=', '>='],
        [:NUMBER, 3]
      ]

      assert_equal compressed, Zaid::Lexer.new.compress(tokens)
    end

    def test_compress_less_than
      tokens = [
        [:NUMBER, 5],
        [:LESS, Lexer::LESS],
        [:THAN, Lexer::THAN],
        [:NUMBER, 3]
      ]

      compressed = [
        [:NUMBER, 5],
        ['<', '<'],
        [:NUMBER, 3]
      ]

      assert_equal compressed, Zaid::Lexer.new.compress(tokens)
    end

    def test_compress_less_than_or_equals
      tokens = [
        [:NUMBER, 5],
        [:LESS, Lexer::LESS],
        [:THAN, Lexer::THAN],
        [:OR, Lexer::OR],
        [:EQUALS, Lexer::EQUALS],
        [:NUMBER, 3]
      ]

      compressed = [
        [:NUMBER, 5],
        ['<=', '<='],
        [:NUMBER, 3]
      ]

      assert_equal compressed, Zaid::Lexer.new.compress(tokens)
    end

    def test_compress_equals
      tokens = [
        [:NUMBER, 5],
        [:EQUALS, Lexer::EQUALS],
        [:NUMBER, 3]
      ]

      compressed = [
        [:NUMBER, 5],
        ['==', '=='],
        [:NUMBER, 3]
      ]

      assert_equal compressed, Zaid::Lexer.new.compress(tokens)
    end

    def test_compress_not_equals
      tokens = [
        [:NUMBER, 5],
        [:NOT, Lexer::NOT],
        [:EQUALS, Lexer::EQUALS],
        [:NUMBER, 3]
      ]

      compressed = [
        [:NUMBER, 5],
        ['!=', '!='],
        [:NUMBER, 3]
      ]

      assert_equal compressed, Zaid::Lexer.new.compress(tokens)
    end

    def test_compress_or
      tokens = [
        [:TRUE, Lexer::TRUE],
        [:OR, Lexer::OR],
        [:FALSE, Lexer::FALSE]
      ]

      compressed = [
        [:TRUE, Lexer::TRUE],
        ['||', '||'],
        [:FALSE, Lexer::FALSE]
      ]

      assert_equal compressed, Zaid::Lexer.new.compress(tokens)
    end

    def test_compress_and
      tokens = [
        [:TRUE, Lexer::TRUE],
        [:AND, Lexer::AND],
        [:FALSE, Lexer::FALSE]
      ]

      compressed = [
        [:TRUE, Lexer::TRUE],
        ['&&', '&&'],
        [:FALSE, Lexer::FALSE]
      ]

      assert_equal compressed, Zaid::Lexer.new.compress(tokens)
    end

    def test_compress_and_between_receive_and_then
      tokens = [
        [:METHOD, Lexer::METHOD],
        [:IDENTIFIER, 'تجربة'],
        [:RECEIVE, Lexer::RECEIVE],
        [:IDENTIFIER, 'المتغير_الأول'],
        [:AND, Lexer::AND],
        [:IDENTIFIER, 'المتغير_الثاني'],
        [:THEN, Lexer::THEN]
      ]

      assert_equal tokens, Zaid::Lexer.new.compress(tokens)
    end
  end
end

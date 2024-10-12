# frozen_string_literal: true

require 'minitest/autorun'

require 'zaid/lexer_components/tokenizer'

module Zaid
  module LexerComponents
    class TokenizerTest < Minitest::Test
      include Keywords

      def setup
        @tokenizer = Tokenizer.new

        def @tokenizer.tokenize(code)
          super(code, run_compression: false)
        end
      end

      def test_newlines
        code = <<~CODE

          # هذا تعليق في بداية البرنامج

          عدد = ٥

          طالما كان عدد أكبر من ٠ إذن
            اطبع(عدد)
            عدد = عدد - ١

          تعليق: هذا تعليق في وسط البرنامج
          ملاحظة: هذه ملاحظة
          اطبع(عدد)
          سؤال: أخيرا، هذا سؤال في نهاية البرنامج

        CODE

        tokens = [
          [:NEWLINE, "\n"],
          [:COMMENT, '# هذا تعليق في بداية البرنامج'],
          [:NEWLINE, "\n"],
          [:NEWLINE, "\n"],
          [:IDENTIFIER, 'عدد'], ['=', '='], [:NUMBER, 5],
          [:NEWLINE, "\n"],
          [:NEWLINE, "\n"],
          [:WHILE, WHILE], [:WAS, WAS], [:IDENTIFIER, 'عدد'], [:GREATER, GREATER], [:THAN, THAN], [:NUMBER, 0], [:THEN, THEN],
          [:INDENT, 2],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:IDENTIFIER, 'عدد'], [')', ')'],
          [:NEWLINE, "\n"],
          [:IDENTIFIER, 'عدد'], ['=', '='], [:IDENTIFIER, 'عدد'], ['-', '-'], [:NUMBER, 1],
          [:DEDENT, 0],
          [:NEWLINE, "\n"],
          [:NEWLINE, "\n"],
          [:COMMENT, 'تعليق: هذا تعليق في وسط البرنامج'],
          [:NEWLINE, "\n"],
          [:COMMENT, 'ملاحظة: هذه ملاحظة'],
          [:NEWLINE, "\n"],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:IDENTIFIER, 'عدد'], [')', ')'],
          [:NEWLINE, "\n"],
          [:COMMENT, 'سؤال: أخيرا، هذا سؤال في نهاية البرنامج'],
          [:NEWLINE, "\n"]
        ]

        assert_equal tokens, @tokenizer.tokenize(code)
      end

      def test_comment
        code = <<~CODE
          # هذا تعليق في بداية البرنامج
          عدد = ٥
          تعليق: هذا تعليق في وسط البرنامج
          ملاحظة: هذه ملاحظة
          اطبع(عدد)
          سؤال: أخيرا، هذا سؤال في نهاية البرنامج
        CODE

        tokens = [
          [:COMMENT, '# هذا تعليق في بداية البرنامج'],
          [:NEWLINE, "\n"],
          [:IDENTIFIER, 'عدد'], ['=', '='], [:NUMBER, 5],
          [:NEWLINE, "\n"],
          [:COMMENT, 'تعليق: هذا تعليق في وسط البرنامج'],
          [:NEWLINE, "\n"],
          [:COMMENT, 'ملاحظة: هذه ملاحظة'],
          [:NEWLINE, "\n"],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:IDENTIFIER, 'عدد'], [')', ')'],
          [:NEWLINE, "\n"],
          [:COMMENT, 'سؤال: أخيرا، هذا سؤال في نهاية البرنامج']
        ]

        assert_equal tokens, @tokenizer.tokenize(code)
      end

      def test_identifier
        assert_equal [[:IDENTIFIER, 'عدد']], @tokenizer.tokenize('عدد')
      end

      def test_number
        assert_equal [[:NUMBER, 314]], @tokenizer.tokenize('٣١٤')
        assert_equal [[:NUMBER, 314]], @tokenizer.tokenize('314')
      end

      def test_float
        assert_equal [[:FLOAT, 3.14]], @tokenizer.tokenize('٣.١٤')
        assert_equal [[:FLOAT, 3.14]], @tokenizer.tokenize('3.14')
      end

      def test_mixed_digits
        assert_equal [[:NUMBER, 314]], @tokenizer.tokenize('3١٤')
      end

      def test_string
        assert_equal [[:STRING, 'زيد']], @tokenizer.tokenize('"زيد"')
      end

      def test_operator
        assert_equal [['||', '||']], @tokenizer.tokenize('||')
        assert_equal [['&&', '&&']], @tokenizer.tokenize('&&')
        assert_equal [['==', '==']], @tokenizer.tokenize('==')
        assert_equal [['!=', '!=']], @tokenizer.tokenize('!=')
        assert_equal [['<=', '<=']], @tokenizer.tokenize('<=')
        assert_equal [['>=', '>=']], @tokenizer.tokenize('>=')
        assert_equal [['<', '<']], @tokenizer.tokenize('<')
        assert_equal [['>', '>']], @tokenizer.tokenize('>')

        assert_equal [[:NUMBER, 5], ['>=', '>='], [:NUMBER, 3]], @tokenizer.tokenize('5 >=3')
        assert_equal [[:NUMBER, 5], ['>=', '>='], [:NUMBER, 3]], @tokenizer.tokenize('5>= 3')
        assert_equal [[:NUMBER, 5], ['>=', '>='], [:NUMBER, 3]], @tokenizer.tokenize('5>=3')
      end

      def test_arabic_operators
        assert_equal [[:NUMBER, 5], [:EQUALS, EQUALS], [:NUMBER, 3]],
                     @tokenizer.tokenize('٥ يساوي ٣')

        assert_equal [[:NUMBER, 5], [:NOT, NOT], [:EQUALS, EQUALS], [:NUMBER, 3]],
                     @tokenizer.tokenize('٥ لا يساوي ٣')

        assert_equal [[:NUMBER, 5], [:GREATER, GREATER], [:THAN, THAN], [:NUMBER, 3]],
                     @tokenizer.tokenize('٥ أكبر من ٣')

        assert_equal [[:NUMBER, 5], [:LESS, LESS], [:THAN, THAN], [:NUMBER, 3]],
                     @tokenizer.tokenize('٥ أصغر من ٣')

        assert_equal [[:NUMBER, 5], [:GREATER, GREATER], [:THAN, THAN], [:OR, OR], [:EQUALS, EQUALS], [:NUMBER, 3]],
                     @tokenizer.tokenize('٥ أكبر من أو يساوي ٣')

        assert_equal [[:NUMBER, 5], [:LESS, LESS], [:THAN, THAN], [:OR, OR], [:EQUALS, EQUALS], [:NUMBER, 3]],
                     @tokenizer.tokenize('٥ أصغر من أو يساوي ٣')
      end

      def test_single_character
        assert_equal [['+', '+']], @tokenizer.tokenize('+')
        assert_equal [['-', '-']], @tokenizer.tokenize('-')
        assert_equal [['*', '*']], @tokenizer.tokenize('*')
        assert_equal [['/', '/']], @tokenizer.tokenize('/')
        assert_equal [['(', '(']], @tokenizer.tokenize('(')
        assert_equal [[')', ')']], @tokenizer.tokenize(')')
      end

      def test_arabic_arithmetic_operator
        assert_equal [[:PLUS, PLUS]], @tokenizer.tokenize('زائد')
        assert_equal [[:MINUS, MINUS]], @tokenizer.tokenize('ناقص')
        assert_equal [[:TIMES, TIMES]], @tokenizer.tokenize('ضرب')
        assert_equal [[:DIVIDE, DIVIDE]], @tokenizer.tokenize('تقسيم')
      end

      def test_if_statement
        code = <<~CODE
          إذا كان ٥ أكبر من ٣ إذن
            اطبع("٥ أكبر من ٣")
        CODE

        tokens = [
          [:IF, IF], [:WAS, WAS], [:NUMBER, 5], [:GREATER, GREATER], [:THAN, THAN], [:NUMBER, 3], [:THEN, THEN],
          [:INDENT, 2],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, '٥ أكبر من ٣'], [')', ')'],
          [:DEDENT, 0],
          [:NEWLINE, "\n"]
        ]

        assert_equal tokens, @tokenizer.tokenize(code)
      end

      def test_if_else_statement
        code = <<~CODE
          إذا كان ٥ أكبر من ٣ إذن
            اطبع("٥ أكبر من ٣")
          وإلا
            اطبع("٥ أصغر من أو يساوي ٣")
        CODE

        tokens = [
          [:IF, IF], [:WAS, WAS], [:NUMBER, 5], [:GREATER, GREATER], [:THAN, THAN], [:NUMBER, 3], [:THEN, THEN],
          [:INDENT, 2],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, '٥ أكبر من ٣'], [')', ')'],
          [:DEDENT, 0],
          [:NEWLINE, "\n"],
          [:ELSE, ELSE],
          [:INDENT, 2],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, '٥ أصغر من أو يساوي ٣'], [')', ')'],
          [:DEDENT, 0],
          [:NEWLINE, "\n"]
        ]

        assert_equal tokens, @tokenizer.tokenize(code)
      end

      def test_else_if_statement
        code = <<~CODE
          إذا كان ٥ أكبر من ٣ إذن
            اطبع("٥ أكبر من ٣")
          وإذا كان ٥ أصغر من ٣ إذن
            اطبع("٥ أصغر من ٣")
          وإلا
            اطبع("٥ يساوي ٣")
        CODE

        tokens = [
          [:IF, IF], [:WAS, WAS], [:NUMBER, 5], [:GREATER, GREATER], [:THAN, THAN], [:NUMBER, 3], [:THEN, THEN],
          [:INDENT, 2],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, '٥ أكبر من ٣'], [')', ')'],
          [:DEDENT, 0],
          [:NEWLINE, "\n"],
          [:ELSE_IF, ELSE_IF], [:WAS, WAS], [:NUMBER, 5], [:LESS, LESS], [:THAN, THAN], [:NUMBER, 3], [:THEN, THEN],
          [:INDENT, 2],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, '٥ أصغر من ٣'], [')', ')'],
          [:DEDENT, 0],
          [:NEWLINE, "\n"],
          [:ELSE, ELSE],
          [:INDENT, 2],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, '٥ يساوي ٣'], [')', ')'],
          [:DEDENT, 0],
          [:NEWLINE, "\n"]
        ]

        assert_equal tokens, @tokenizer.tokenize(code)
      end

      def test_while_statement
        code = <<~CODE
          عدد = ٥
          طالما كان عدد أكبر من ٠ إذن
            اطبع(عدد)
            عدد = عدد - ١
            توقف
            التالي
        CODE

        tokens = [
          [:IDENTIFIER, 'عدد'], ['=', '='], [:NUMBER, 5],
          [:NEWLINE, "\n"],
          [:WHILE, WHILE], [:WAS, WAS], [:IDENTIFIER, 'عدد'], [:GREATER, GREATER], [:THAN, THAN], [:NUMBER, 0], [:THEN, THEN],
          [:INDENT, 2],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:IDENTIFIER, 'عدد'], [')', ')'],
          [:NEWLINE, "\n"],
          [:IDENTIFIER, 'عدد'], ['=', '='], [:IDENTIFIER, 'عدد'], ['-', '-'], [:NUMBER, 1],
          [:NEWLINE, "\n"],
          [:BREAK, BREAK],
          [:NEWLINE, "\n"],
          [:CONTINUE, CONTINUE],
          [:DEDENT, 0],
          [:NEWLINE, "\n"]
        ]

        assert_equal tokens, @tokenizer.tokenize(code)
      end

      def test_method
        code = <<~CODE
          دالة جمع_٣_أعداد تستقبل العدد_الأول و العدد_الثاني و العدد_الثالث وهي
            العدد_الأول + العدد_الثاني + العدد_الثالث
        CODE

        tokens = [
          [:METHOD, METHOD],
          [:IDENTIFIER, 'جمع_٣_أعداد'], [:RECEIVE, RECEIVE], [:IDENTIFIER, 'العدد_الأول'], [:AND, AND], [:IDENTIFIER, 'العدد_الثاني'], [:AND, AND], [:IDENTIFIER, 'العدد_الثالث'], [:IT_IS, IT_IS],
          [:INDENT, 2],
          [:IDENTIFIER, 'العدد_الأول'], ['+', '+'], [:IDENTIFIER, 'العدد_الثاني'], ['+', '+'], [:IDENTIFIER, 'العدد_الثالث'],
          [:DEDENT, 0],
          [:NEWLINE, "\n"]
        ]

        assert_equal tokens, @tokenizer.tokenize(code)
      end

      def test_class
        code = <<~CODE
          نوع الحيوانات هو
            دالة المشي وهي
              اطبع("الحيوان يمشي")
        CODE

        tokens = [
          [:CLASS, CLASS], [:CONSTANT, 'الحيوانات'], [:IS, IS],
          [:INDENT, 2],
          [:METHOD, METHOD], [:IDENTIFIER, 'المشي'], [:IT_IS, IT_IS],
          [:INDENT, 4],
          [:IDENTIFIER, 'اطبع'], ['(', '('], [:STRING, 'الحيوان يمشي'], [')', ')'],
          [:DEDENT, 2],
          [:NEWLINE, "\n"],
          [:DEDENT, 0],
          [:NEWLINE, "\n"]
        ]

        assert_equal tokens, @tokenizer.tokenize(code)
      end

      def test_dedent_error
        code = <<~CODE
          عدد = ٥
            عدد = عدد + ١
        CODE

        error = assert_raises(RuntimeError) do
          @tokenizer.tokenize(code)
        end

        assert_equal 'خطأ في المسافة البادئة للأسطر.', error.message
      end

      def test_zero_indent_error
        code = <<~CODE
          دالة تجربة وهي
          اطبع("تجربة")
        CODE

        error = assert_raises(RuntimeError) do
          @tokenizer.tokenize(code)
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
          @tokenizer.tokenize(code)
        end

        assert_equal(
          'خطأ في المسافة البادئة للأسطر، المسافة البادئة هي 2 والمسافة البادئة المتوقعة يجب أن تكون أكبر من 2',
          error.message
        )
      end

      def test_question_mark_in_method_call
        assert_equal [[:NUMBER, 1], ['.', '.'], [:IDENTIFIER, 'صفر؟']], @tokenizer.tokenize('١.صفر؟')
      end

      def test_question_mark_in_method_name
        assert_equal [[:METHOD, METHOD], [:IDENTIFIER, 'صفر؟']], @tokenizer.tokenize('دالة صفر؟')
      end
    end
  end
end

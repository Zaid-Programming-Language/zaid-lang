# frozen_string_literal: true

require 'minitest/autorun'

require 'interpreter'

module Zaid
  class InterpreterTest < Minitest::Test
    def setup
      @interpreter = Interpreter.new
    end

    def test_number
      assert_equal 1, @interpreter.eval('١').ruby_value
    end

    def test_float
      assert_equal 1.5, @interpreter.eval('١.٥').ruby_value
    end

    def test_string
      assert_equal 'زيد', @interpreter.eval('"زيد"').ruby_value
    end

    def test_true
      assert_equal true, @interpreter.eval('صحيح').ruby_value
    end

    def test_false
      assert_equal false, @interpreter.eval('خاطئ').ruby_value
    end

    def test_nil
      assert_nil @interpreter.eval('مجهول').ruby_value
    end

    def test_arithmetic_operations_on_integers
      assert_equal 3, @interpreter.eval('١ + ٢').ruby_value
      assert_equal(-1, @interpreter.eval('١ - ٢').ruby_value)
      assert_equal 2, @interpreter.eval('١ * ٢').ruby_value
      assert_equal 0, @interpreter.eval('١ / ٢').ruby_value
    end

    def test_arithmetic_operations_on_floats
      assert_equal 3.0, @interpreter.eval('١.٠ + ٢').ruby_value
      assert_equal(-1.0, @interpreter.eval('١.٠ - ٢').ruby_value)
      assert_equal 2.0, @interpreter.eval('١.٠ * ٢').ruby_value
      assert_equal 0.5, @interpreter.eval('١.٠ / ٢').ruby_value
    end

    def test_arithmetic_operations_on_strings
      assert_equal 'زيد', @interpreter.eval('"زي" + "د"').ruby_value
      assert_equal 'زيدزيد', @interpreter.eval('"زيد" * ٢').ruby_value
    end

    def test_arabic_arithmetic_operations
      assert_equal 3, @interpreter.eval('١ زائد ٢').ruby_value
      assert_equal(-1, @interpreter.eval('١ ناقص ٢').ruby_value)
      assert_equal 2, @interpreter.eval('١ ضرب ٢').ruby_value
      assert_equal 0, @interpreter.eval('١ تقسيم ٢').ruby_value
    end

    def test_comparison_operations_on_integers
      assert_equal true, @interpreter.eval('١ == ١').ruby_value
      assert_equal true, @interpreter.eval('١ != ٢').ruby_value
      assert_equal true, @interpreter.eval('١ < ٢').ruby_value
      assert_equal true, @interpreter.eval('١ <= ١').ruby_value
      assert_equal true, @interpreter.eval('٢ > ١').ruby_value
      assert_equal true, @interpreter.eval('١ >= ١').ruby_value
    end

    def test_comparison_operations_on_floats
      assert_equal true, @interpreter.eval('١.٠ == ١.٠').ruby_value
      assert_equal true, @interpreter.eval('١.٠ != ٢.٠').ruby_value
      assert_equal true, @interpreter.eval('١.٠ < ٢.٠').ruby_value
      assert_equal true, @interpreter.eval('١.٠ <= ١.٠').ruby_value
      assert_equal true, @interpreter.eval('٢.٠ > ١.٠').ruby_value
      assert_equal true, @interpreter.eval('١.٠ >= ١.٠').ruby_value
    end

    def test_comparison_operations_on_strings
      assert_equal true, @interpreter.eval('"زيد" == "زيد"').ruby_value
      assert_equal true, @interpreter.eval('"زيد" != "زياد"').ruby_value
      assert_equal false, @interpreter.eval('"زيد" < "زياد"').ruby_value
      assert_equal true, @interpreter.eval('"زيد" <= "زيد"').ruby_value
      assert_equal false, @interpreter.eval('"زياد" > "زيد"').ruby_value
      assert_equal true, @interpreter.eval('"زيد" >= "زيد"').ruby_value
    end

    def test_arabic_comparison_operations
      assert_equal true, @interpreter.eval('١ يساوي ١').ruby_value
      assert_equal true, @interpreter.eval('١ لا يساوي ٢').ruby_value
      assert_equal true, @interpreter.eval('١ أصغر من ٢').ruby_value
      assert_equal true, @interpreter.eval('١ أصغر من أو يساوي ١').ruby_value
      assert_equal true, @interpreter.eval('٢ أكبر من ١').ruby_value
      assert_equal true, @interpreter.eval('١ أكبر من أو يساوي ١').ruby_value
    end

    def test_assign
      code = <<~CODE
        عدد = ٥
        ٣
        عدد
      CODE

      assert_equal 5, @interpreter.eval(code).ruby_value
    end

    def test_method
      code = <<~CODE
        دالة جمع_٣_أعداد تستقبل العدد_الأول و العدد_الثاني و العدد_الثالث وهي
          العدد_الأول + العدد_الثاني + العدد_الثالث

        جمع_٣_أعداد(١، ٢، ٣)
      CODE

      assert_equal 6, @interpreter.eval(code).ruby_value
    end

    def test_class
      code = <<~CODE
        نوع الحيوانات هو
          دالة المشي وهي
            اطبع("الحيوان يمشي")

        الحيوانات.جديد.المشي
      CODE

      assert_output("الحيوان يمشي\n") do
        @interpreter.eval(code)
      end
    end

    def test_reopen_class
      code = <<~CODE
        نوع عدد_صحيح هو
          دالة تجربة وهي
            ٥

        ١.تجربة
      CODE

      assert_equal 5, @interpreter.eval(code).ruby_value
    end

    def test_if
      code = <<~CODE
        إذا كان صحيح إذن
          اطبع("إنه يعمل!")
      CODE

      assert_output("إنه يعمل!\n") { @interpreter.eval(code) }
    end

    def test_if_else
      code = <<~CODE
        إذا كان خاطئ إذن
          اطبع("إنه صحيح!")
        وإلا
          اطبع("إنه خاطئ!")
      CODE

      assert_output("إنه خاطئ!\n") { @interpreter.eval(code) }
    end

    def test_while
      code = <<~CODE
        عدد = ٥

        طالما كان عدد أكبر من ٠ إذن
          اطبع(عدد)
          عدد = عدد - ١
      CODE

      assert_output("5\n4\n3\n2\n1\n") { @interpreter.eval(code) }
    end
  end
end

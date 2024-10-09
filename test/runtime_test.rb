# frozen_string_literal: true

require 'minitest/autorun'

require 'runtime'

module Zaid
  class RuntimeTest < Minitest::Test
    def test_get_constant
      refute_nil Constants['الشيء']
    end

    def test_create_an_object
      assert_equal Constants['الشيء'], Constants['الشيء'].new.runtime_class
    end

    def test_create_an_object_mapped_to_ruby_value
      assert_equal 32, Constants['العدد_الصحيح'].new_with_value(32).ruby_value
    end

    def test_lookup_method_in_class
      refute_nil Constants['الشيء'].lookup('اطبع')

      assert_raises(RuntimeError) { Constants['الشيء'].lookup('غير_موجودة') }
    end

    def test_call_method
      assert_equal Constants['الشيء'], Constants['الشيء'].call('جديد').runtime_class
    end

    def test_a_class_is_a_class
      assert_equal Constants['النوع'], Constants['العدد_الصحيح'].runtime_class
    end
  end
end

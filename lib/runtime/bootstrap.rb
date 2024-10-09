# frozen_string_literal: true

require_relative './zaid_class'
require_relative './context'

ARITHMETIC_OPERATIONS = %i[+ * - /].freeze
COMPARISON_OPERATIONS = %i[> < >= <= == !=].freeze

def define_arithmetic_operations(class_name, operations)
  operations.each do |operation|
    Constants[class_name].def operation do |receiver, arguments|
      perform_arithmetic_operation(receiver, arguments, operation, class_name)
    end
  end
end

def perform_arithmetic_operation(receiver, arguments, operation, class_name)
  result = receiver.ruby_value.send(operation, arguments.first.ruby_value)

  Constants[class_name].new_with_value(result)
end

def define_comparison_operations(class_name, operations)
  operations.each do |operation|
    Constants[class_name].def operation do |receiver, arguments|
      result = receiver.ruby_value.send(operation, arguments.first.ruby_value)

      result ? Constants['صحيح'] : Constants['خاطئ']
    end
  end
end

Constants = {}

Constants['النوع'] = Zaid::Runtime::ZaidClass.new
Constants['النوع'].runtime_class = Constants['النوع']
Constants['الشيء'] = Zaid::Runtime::ZaidClass.new(Constants['النوع'])
Constants['العدد_الصحيح'] = Zaid::Runtime::ZaidClass.new(Constants['الشيء'])
Constants['العدد_العشري'] = Zaid::Runtime::ZaidClass.new(Constants['الشيء'])
Constants['النص'] = Zaid::Runtime::ZaidClass.new(Constants['الشيء'])

root_self = Constants['الشيء'].new
RootContext = Zaid::Runtime::Context.new(root_self)

Constants['النوع_الصحيح'] = Zaid::Runtime::ZaidClass.new(Constants['الشيء'])
Constants['النوع_الخاطئ'] = Zaid::Runtime::ZaidClass.new(Constants['الشيء'])
Constants['النوع_المجهول'] = Zaid::Runtime::ZaidClass.new(Constants['الشيء'])

Constants['صحيح'] = Constants['النوع_الصحيح'].new_with_value(true)
Constants['خاطئ'] = Constants['النوع_الخاطئ'].new_with_value(false)
Constants['مجهول'] = Constants['النوع_المجهول'].new_with_value(nil)

Constants['النوع'].def :جديد do |receiver, _arguments|
  receiver.new
end

Constants['الشيء'].def :اطبع do |_receiver, arguments|
  puts arguments.first.ruby_value

  Constants['مجهول']
end

define_arithmetic_operations('العدد_الصحيح', ARITHMETIC_OPERATIONS)
define_arithmetic_operations('العدد_العشري', ARITHMETIC_OPERATIONS)
define_arithmetic_operations('النص', ARITHMETIC_OPERATIONS[0..1])

define_comparison_operations('العدد_الصحيح', COMPARISON_OPERATIONS)
define_comparison_operations('العدد_العشري', COMPARISON_OPERATIONS)
define_comparison_operations('النص', COMPARISON_OPERATIONS)

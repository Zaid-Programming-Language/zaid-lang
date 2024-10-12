# frozen_string_literal: true

require_relative 'context'
require_relative 'zaid_class'

ARITHMETIC_OPERATIONS = %i[+ * - /].freeze
COMPARISON_OPERATIONS = %i[> < >= <= == !=].freeze

def define_arithmetic_operations(class_name, operations)
  operations.each do |operation|
    Constants[class_name].def operation do |receiver, arguments|
      perform_arithmetic_operation(receiver, arguments, operation, class_name)
    end
  end
end

def define_comparison_operations(class_name, operations)
  operations.each do |operation|
    Constants[class_name].def operation do |receiver, arguments|
      result = receiver.ruby_value.send(operation, arguments.first.ruby_value)

      result ? Constants['صحيح'] : Constants['خاطئ']
    end
  end
end

def perform_arithmetic_operation(receiver, arguments, operation, class_name)
  result = receiver.ruby_value.send(operation, arguments.first.ruby_value)

  Constants[class_name].new_with_value(result)
end

Constants = {}

Constants['نوع'] = Zaid::Runtime::ZaidClass.new
Constants['نوع'].runtime_class = Constants['نوع']
Constants['شيء'] = Zaid::Runtime::ZaidClass.new(Constants['نوع'])
Constants['عدد_صحيح'] = Zaid::Runtime::ZaidClass.new(Constants['شيء'])
Constants['عدد_عشري'] = Zaid::Runtime::ZaidClass.new(Constants['شيء'])
Constants['نص'] = Zaid::Runtime::ZaidClass.new(Constants['شيء'])
Constants['مصفوفة'] = Zaid::Runtime::ZaidClass.new(Constants['شيء'])

root_self = Constants['شيء'].new
RootContext = Zaid::Runtime::Context.new(root_self)

Constants['نوع_صحيح'] = Zaid::Runtime::ZaidClass.new(Constants['شيء'])
Constants['نوع_خاطئ'] = Zaid::Runtime::ZaidClass.new(Constants['شيء'])
Constants['نوع_مجهول'] = Zaid::Runtime::ZaidClass.new(Constants['شيء'])

Constants['صحيح'] = Constants['نوع_صحيح'].new_with_value(true)
Constants['خاطئ'] = Constants['نوع_خاطئ'].new_with_value(false)
Constants['مجهول'] = Constants['نوع_مجهول'].new_with_value(nil)

Constants['نوع'].def :جديد do |receiver, _arguments|
  receiver.new
end

Constants['شيء'].def :اطبع do |_receiver, arguments|
  puts arguments.first.ruby_value

  Constants['مجهول']
end

Constants['شيء'].def :'&&' do |receiver, arguments|
  receiver.ruby_value && arguments.first.ruby_value
end

Constants['شيء'].def :'||' do |receiver, arguments|
  receiver.ruby_value || arguments.first.ruby_value
end

define_arithmetic_operations('عدد_صحيح', ARITHMETIC_OPERATIONS)
define_arithmetic_operations('عدد_عشري', ARITHMETIC_OPERATIONS)
define_arithmetic_operations('نص', ARITHMETIC_OPERATIONS[0..1])

define_comparison_operations('عدد_صحيح', COMPARISON_OPERATIONS)
define_comparison_operations('عدد_عشري', COMPARISON_OPERATIONS)
define_comparison_operations('نص', COMPARISON_OPERATIONS)

Constants['مصفوفة'].def :أضف do |receiver, arguments|
  receiver.ruby_value << arguments.first
end

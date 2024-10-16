# frozen_string_literal: true

require 'rake/testtask'

desc 'Run unit tests'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'

  t.test_files = FileList['test/**/*_test.rb']
end

desc 'Generate parser from grammar'
task :generate_parser do
  sh 'racc -o lib/zaid/parser.rb lib/zaid/grammar.y'

  # Modify the generated parser to wrap it in the Zaid module.
  parser_content = File.read('lib/zaid/parser.rb')

  modified_content = parser_content.sub(
    'class Parser < Racc::Parser',
    "module Zaid\n  class Parser < Racc::Parser\n    include Nodes"
  )

  modified_content << "\nend" # Close the Zaid module.

  File.write('lib/zaid/parser.rb', modified_content)
end

desc 'Run benchmark'
task :benchmark do
  require 'benchmark/ips'

  require './lib/zaid/interpreter'

  code = File.read('syntax.zaid')
  interpreter = Zaid::Interpreter.new

  Benchmark.ips do |x|
    x.report('Interpreter#eval') do
      original_stdout = $stdout
      $stdout = File.open(File::NULL, 'w')
      interpreter.eval(code)
      $stdout = original_stdout
    end
  end
end

desc 'Count lines of code'
task :cloc do
  puts 'Source code:'
  sh 'cloc lib --exclude-list-file=lib/zaid/parser.rb'

  puts ''

  puts 'Tests:'
  sh 'cloc test'
end

task default: :test

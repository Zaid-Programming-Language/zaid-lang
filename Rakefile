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
  sh 'racc -o lib/parser.rb lib/grammar.y'

  # Modify the generated parser to wrap it in the Zaid module.
  parser_content = File.read('lib/parser.rb')

  modified_content = parser_content.sub(
    /class Parser < Racc::Parser/,
    "module Zaid\n  class Parser < Racc::Parser\n    include Nodes"
  )
  modified_content << "\nend" # Close the Zaid module.

  File.write('lib/parser.rb', modified_content)
end

task default: :test

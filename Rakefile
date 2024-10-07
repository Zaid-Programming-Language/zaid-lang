# frozen_string_literal: true

require 'rake/testtask'

desc 'Run unit tests'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
end

task default: :test

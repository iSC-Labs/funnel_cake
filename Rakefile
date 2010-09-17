require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the funnel_cake plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the funnel_cake plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'FunnelCake'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :whitespace do
  desc 'Removes trailing whitespace'
  task :clean do
    sh %{find . -name '*.rb' -exec sed -i '' 's/ *$//g' {} \\;}
  end
  task :retab do
    sh %{find . -name '*.rb' -exec sed -i '' 's/\t/  /g' {} \\;}
  end
end

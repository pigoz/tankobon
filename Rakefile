$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "tankobon/version"

begin
  require 'rspec/core/rake_task'
rescue LoadError
  puts 'To use rspec for testing you must install rspec gem:'
  puts 'gem install rspec'
  exit
end

task :build do
  system "gem build tankobon.gemspec"
end

task :install => :build do
  system "gem install tankobon-#{Tankobon::VERSION}.gem"
end

task :clear do
  File.delete File.join(Dir.pwd, "tankobon-#{Tankobon::VERSION}.gem")
end

task :release => :build do
  system "gem push tankobon-#{Tankobon::VERSION}.gem"
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = ['--color']
end

RSpec::Core::RakeTask.new(:specdoc) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = ['--color --format documentation']
end

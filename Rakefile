$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "tankobon/version"

begin
  require 'spec/rake/spectask'
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
  system "gem push tankobon-#{Tankobon::VERSION}"
end

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = Dir.glob('spec/**/*_spec.rb')
end

Spec::Rake::SpecTask.new(:specdoc) do |t|
  t.spec_files = Dir.glob('spec/**/*_spec.rb')
  t.spec_opts << '--format specdoc'
end
# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'tankobon/version'

Gem::Specification.new do |s|
  s.name = 'tankobon'
  s.version = Tankobon::VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = 'Converts manga scans'
  s.description = %{Script for resizing manga scans for the e-book readers}
  #
  s.author = 'Stefano Pigozzi'
  s.email = 'stefano.pigozzi@gmail.com'
  s.homepage = 'http://stefanopigozzi.com'
  #
  s.files = Dir.glob("**/{bin,lib}/**/*")
  s.executables  = ['tankobon']
  s.require_path = 'lib'
  #
  s.add_dependency 'trollop', '>= 1.16.0'
  #
  s.has_rdoc = true
end

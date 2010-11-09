require 'rspec'
require 'fileutils'

require File.join(File.dirname(File.dirname(__FILE__)), "lib", "tankobon.rb")
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

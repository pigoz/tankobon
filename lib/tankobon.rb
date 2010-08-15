require 'fileutils'
require 'tankobon/open-classes/file.rb'
require 'tankobon/open-classes/dir.rb'
require 'tankobon/version'
require 'tankobon/variables'

module Tankobon
  autoload :Application,  'tankobon/application'
  autoload :Archive,      'tankobon/archive'
  autoload :CLI,          'tankobon/cli'
  autoload :Sanitizer,    'tankobon/sanitizer'
end
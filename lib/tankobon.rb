require 'fileutils'
require 'pathname'

Dir[File.dirname(__FILE__) + '/ext/*.rb'].each do |file| 
  require File.basename(file, File.extname(file))
end

require 'tankobon/version'

module Tankobon
  autoload :Application,     'tankobon/application'
  autoload :Archive,         'tankobon/archive'
  autoload :CLI,             'tankobon/cli'
  autoload :Directory,       'tankobon/directory'
  autoload :Sanitizer,       'tankobon/sanitizer'
  autoload :StagedDirectory, 'tankobon/stageddirectory'
end
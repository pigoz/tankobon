require 'fileutils'
require 'pathname'

require 'tankobon/ext/dir'
require 'tankobon/ext/file'
require 'tankobon/optionsmap'
require 'tankobon/version'

module Tankobon
  autoload :Application,     'tankobon/application'
  autoload :Archive,         'tankobon/archive'
  autoload :CLI,             'tankobon/cli'
  autoload :Directory,       'tankobon/directory'
  autoload :Sanitizer,       'tankobon/sanitizer'
  autoload :StagedDirectory, 'tankobon/stageddirectory'
end
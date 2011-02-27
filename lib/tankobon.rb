require 'fileutils'
require 'pathname'

require 'tankobon/ext/string'
require 'tankobon/ext/dir'
require 'tankobon/ext/file'
require 'tankobon/optionsmap'
require 'tankobon/transform'
require 'tankobon/version'

module Tankobon
  autoload :Application,        'tankobon/application'
  autoload :Archive,            'tankobon/archive'
  autoload :CLI,                'tankobon/cli'
  autoload :Directory,          'tankobon/directory'
  autoload :Stageable,          'tankobon/stageable'
  autoload :StagedDirectory,    'tankobon/stageddirectory'
end

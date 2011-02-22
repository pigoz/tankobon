require 'fileutils'
require 'pathname'

require 'tankobon/ext/dir'
require 'tankobon/ext/file'
require 'tankobon/optionsmap'
require 'tankobon/version'

module Tankobon
  autoload :Application,        'tankobon/application'
  autoload :Archive,            'tankobon/archive'
  autoload :CLI,                'tankobon/cli'
  autoload :DefaultSanitizer,   'tankobon/defaultsanitizer'
  autoload :Directory,          'tankobon/directory'
  autoload :StagedDirectory,    'tankobon/stageddirectory'
end

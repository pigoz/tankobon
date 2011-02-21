require 'pathname'

module Tankobon
  class Stageable
    def initialize(stageable)
      @stageable = stageable
    end
    
    def stage_root
      Pathname.new("~/tankobon2")
    end
    
    def stage(stageable)
      stage_root + stageable.basename('.*')
    end
    
    def to_stage(&block)
      FileUtils.mkdir_p(stage.dirname) unless stage.dirname.exist?
      FileUtils.rm_r(stage) if stage.exist?
      yield if block_given?
      StagedDirectory.new(stage)
    end
  end
end
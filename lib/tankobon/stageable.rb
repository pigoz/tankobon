require 'pathname'

module Tankobon
  class Stageable
    def initialize(stageable)
      @stageable = Pathname.new(stageable)
    end
    
    def stage_root
      Pathname.new("~/tankobon2").expand_path
    end
    
    def stage
      stage_root + @stageable.basename('.*')
    end
    
    def stageable
      @stageable.expand_path
    end
    
    def to_stage(&block)
      FileUtils.mkdir_p(stage.dirname) unless stage.dirname.exist?
      FileUtils.rm_r(stage) if stage.exist?
      yield if block_given?
      StagedDirectory.new(stage)
    end
  end
end
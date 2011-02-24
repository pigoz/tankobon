module Tankobon
  class Archive < Stageable
    def to_stage
      super do
        FileUtils.mkdir_p(stage) unless stage.exist?
        %x{cd #{stage.realpath} && 7za x -r #{@stageable.realpath}}
      end
    end
  end
end
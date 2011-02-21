module Tankobon
  class Archive < Stageable
    def to_stage
      super do
        FileUtils.mkdir_p(stage) unless stage.exist?
        sh %{cd #{stage} && 7za x -r #{@stageable}} # uses 7ip to deflate
      end
    end
  end
end
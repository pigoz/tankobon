module Tankobon
  class Directory < Stageable
    def to_stage
      super do
        FileUtils.cp_r(@stageable, stage)
      end
    end
  end
end
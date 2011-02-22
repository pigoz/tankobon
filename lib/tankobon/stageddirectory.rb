module Tankobon  
  class StagedDirectory
    def initialize(stage)
      @stage = stage
    end
    
    def sanitize(sanitizer=DefaultSanitizer)
      dir_listing = Dir.glob(File.join(@stage, "**", "*"))
      dir_listing.sort {|a,b| b <=> a}.each do |file|
        File.xform(file) do
          sanitizer.sanitize(File.splitbase(file)[0])
        end
      end
    end
    
    def mv_images_to_root(renamer=SequenceRenamer)
      # todo
    end
    
    def clean()
      # todo
    end
    
    def convert_images(converter=KindleDXConverter)
    end
  end
end
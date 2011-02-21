module Tankobon  
  class StagedDirectory
    def initialize(stage)
      @stage = stage
    end
    
    def sanitize(sanitizer=DefaultSanitizer)
      list = Dir.glob(File.join("**", "*.{jpg,jpeg,gif,png}"))
      sanitizer.sanitize
      # todo
    end
    
    def convert_images(converter=KindleDXConverter)
    end
  end
end
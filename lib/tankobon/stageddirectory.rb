module Tankobon
  class StagedDirectory
    attr_reader :stage
    
    def initialize(stage)
      @stage = Pathname.new(stage)
    end
    
    def sanitize(sanitizer=SanitizeTransform.new)
      dir_listing = Dir.glob(File.join(@stage, "**", "*"))
      dir_listing.sort {|a,b| b <=> a}.each do |file|
        File.xform(file, &sanitizer)
      end
      self
    end
    
    def rename_images(renamer=SequenceTransform.new)
      images.each do |file|
        File.xform(@stage + File.basename(file), &renamer)
      end
      self
    end
    
    def mv_images_to(directory)
      images.each do |file|
        FileUtils.mv(file, Pathname.new(directory) + File.basename(file))
      end
      self
    end
    
    def mv_images_to_root
      mv_images_to @stage
    end
    
    def clean
      Dir.glob(@stage + "*").each do |file|
        FileUtils.rm_r(file) unless File.image?(file)
      end
      self
    end
    
    def images
      images_wildcard = "*.{#{File.image_extensions.join(",")}}"
      Dir.glob(File.join(@stage, "**", images_wildcard))
    end
    
    def convert_images(converter=KindleDXConverter)
    end
  end
end
module Tankobon
  class StagedDirectory
    attr_reader :stage
    
    def initialize(stage)
      @stage = Pathname.new(stage)
    end
    
    def rename_images(&block); rename(:images, &block); end
    def rename_all(&block); rename(:all, &block); end
    
    def rename(what, &block)
      send(what).each do |file|
        File.xform(file, &block)
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
    
    def all
      Dir.glob(File.join(@stage, "**", "*")).reverse
    end
    
    def images
      images_wildcard = "*.{#{File.image_extensions.join(",")}}"
      Dir.glob(File.join(@stage, "**", images_wildcard))
    end
    
    def convert_images(converter=KindleDXConverter)
    end
  end
end
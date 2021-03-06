module Tankobon
  class StagedDirectory
    attr_reader :stage
    
    def initialize(stage)
      @stage = Pathname.new(stage)
    end
    
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
      mv_images_to stage
      self
    end
    
    def clean
      all_in_root.each do |file|
        FileUtils.rm_r(file) unless File.image?(file)
      end
      self
    end
    
    def all
      join_stage stage_glob(File.join("**", "*")).sort.reverse
    end
    
    def images
      images_wildcard = "*.{#{File.image_extensions.join(",")}}"
      join_stage stage_glob(File.join("**", images_wildcard)).sort
    end
    
    def all_in_root
      join_stage stage_glob("*").sort
    end
    
    def convert_images(&conversion)
      images.each do |file|
        yield(file) if block_given?
      end
    end
    
    def method_missing(name, *args, &block)
      if name =~ /^rename_(\w+)$/
        rename($1.to_sym, &block)
      elsif
        super
      end
    end
    
    private
    def stage_glob(pattern)
      Dir.chdir(stage){ Dir.glob(pattern) }
    end
    
    def join_stage(ary)
      ary.map{|x| stage + x}.map(&:to_s)
    end
  end
end
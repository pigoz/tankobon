module Tankobon
  class Application
    
    def initialize
      no_batch
    end
    
    def batch(name)
      if name then
        @batch = name
        @archive = batched_class(Archive)
        @directory = batched_class(Directory)
      else
        no_batch
      end
      self
    end
    
    def with_base(base, ary)
      with(ary.map{|x| File.join(base, x)})
    end
    
    def with(ary)
      @staged_ary = ary.map do |elem|
        obj = File.archive?(elem) ? @archive : @directory
        obj.new(elem).to_stage
      end
      self
    end
    
    def sanitize(transforms = [SanitizeTransform, SequenceTransform])
      staged_elems.each do |sd|
        transforms.each {|tx| sd.rename_all(&tx.new)}
        sd.mv_images_to_root.clean
      end
      self
    end
    
    def convert(converters = [KindleDXConverter])
      staged_elems.each do |sd|
        converters.each {|tx| sd.convert_images(&tx.new)}
      end
      self
    end
    
    private
    def batched_class(klass)
      Class.new(klass) do
        def stage_root; super.stage_root + @batch; end
      end
    end
    
    def no_batch
      @batch = nil
      @archive = Archive
      @directory = Directory
    end
    
    def staged_elems
      raise "You called sanitize or convert before with." unless @staged_ary
      @batch ? File.dirname(@staged_ary[0]) : @staged_ary
    end
  end
end
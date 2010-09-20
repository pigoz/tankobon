module Tankobon
  class Application
    
    acts_as_options_map
    add_default :batch, nil
    add_default :dir, Dir.pwd
    add_default :im, true
    
    def initialize(&block)
      @filename_count = 0
      @options = {}
      FileUtils.mkdir_p Tankobon::WORK_PATH unless 
        File.exists? Tankobon::WORK_PATH
      apply_defaults!()
      block.arity < 1 ? self.instance_eval(&block) : block.call(self) if
        block_given?
    end
    
    def clear!
      FileUtils.rm_rf Tankobon::WORK_PATH
      FileUtils.mkdir_p Tankobon::WORK_PATH unless 
        File.exists? Tankobon::WORK_PATH
    end
    
    def setup_option_batch!
      return if get(:batch).nil?
      FileUtils.mkdir_p File.join(Tankobon::WORK_PATH, get(:batch)) unless 
        File.exists? File.join(Tankobon::WORK_PATH, get(:batch))
    end
    
    def rename_batch!(archive)
      @filename_count = archive.filename_count
      Dir.foreach(archive.directory) do |file|
        next if file =~ /^\..*$/
        File.rename(File.join(archive.directory, file), \
        File.join(Tankobon::WORK_PATH, get(:batch), file))
      end
    end
    
    def process_files!
      get(:files).each do |archive|
        next unless 
          ['.zip', '.cbz', '.rar', '.cbr', nil]
          .include? File.basename_ext(archive)[1]
          
        Tankobon::Archive.new(File.join(get(:dir), archive), @filename_count) do |a|
          a.transfer(self, [:colorspace, :size])
          a.sanitize!
          a.process_images! if get(:im)
          rename_batch! a unless get(:batch).nil?
        end # / Tankobon::Archive
        
      end
    end
    
  end
end
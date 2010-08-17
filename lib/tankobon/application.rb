module Tankobon
  class Application
    
    def self.make(&block)
      Tankobon::Application.new(&block)
    end
    
    def initialize(&block)
      @filename_count = 0
      @options = {}
      FileUtils.mkdir_p Tankobon::WORK_PATH unless 
        File.exists? Tankobon::WORK_PATH
      config_defaults!()
      block.call(self)
    end
    
    def clear!
      FileUtils.rm_rf Tankobon::WORK_PATH
      FileUtils.mkdir_p Tankobon::WORK_PATH unless 
        File.exists? Tankobon::WORK_PATH
    end
    
    def config_defaults!()
      set :batch, nil
      set :dir, Dir.pwd
    end
    
    def set(key, value)
      @options[key.to_sym] = value
      self.send("setup_option_#{key.to_s}!".to_sym) if
        self.respond_to? "setup_option_#{key.to_s}!"
    end
    
    def get(key)
      @options[key.to_sym]
    end
        
    def setup_option_batch!
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
          
        Tankobon::Archive.make(File.join(get(:dir), archive), @filename_count) do |a|
          a.sanitize!
          a.process_images!
          rename_batch! a unless get(:batch).nil?
        end # / Tankobon::Archive
        
      end
    end
    
  end
end
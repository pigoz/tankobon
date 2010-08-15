module Tankobon
  class Application
    attr_accessor :batch
    attr_accessor :batch_given
    attr_accessor :dir
    attr_accessor :files
    
    def self.make(&block)
      a = Tankobon::Application.new(Dir.pwd)
      block.call(a)
      a.make_batch_dir! if a.batch_given
      a
    end
    
    def initialize(dir)
      @filename_count = 0
      FileUtils.mkdir_p Tankobon::WORK_PATH unless 
        File.exists? Tankobon::WORK_PATH
    end
    
    def clear!
      FileUtils.rm_rf Tankobon::WORK_PATH
      FileUtils.mkdir_p Tankobon::WORK_PATH unless 
        File.exists? Tankobon::WORK_PATH
    end
    
    def use_opts!(opts={})
      opts[:batch] ||= nil
      opts[:batch_given] ||= false
      @dir = dir
      @batch = opts[:batch]
      @batch_given = opts[:batch_given]
      a.make_batch_dir! if @batch_given
    end
    
    def make_batch_dir!
      FileUtils.mkdir_p File.join(Tankobon::WORK_PATH, @batch) unless 
        File.exists? File.join(Tankobon::WORK_PATH, @batch)
    end
    
    def rename_batch!(archive)
      @filename_count = archive.filename_count
      Dir.foreach(archive.directory) do |file|
        next if file =~ /^\..*$/
        File.rename(File.join(archive.directory, file), \
        File.join(Tankobon::WORK_PATH, @batch, file))
      end
    end

    def process_files!
      @files.each do |archive|
        Tankobon::Archive.make(File.join(@dir, archive), @filename_count) do |a|
          a.sanitize!
          a.process_images!
          rename_batch! a if @batch_given
        end # / Tankobon::Archive
      end
    end

    def process_dir!
      Dir.foreach(@dir) do |archive|
        next if archive =~ /^\..*$/
        next unless 
          ['.zip', '.cbz', '.rar', '.cbr', nil]
          .include? File.basename_ext(archive)[1]
        Tankobon::Archive.make(File.join(@dir, archive), @filename_count) do |a|
          a.sanitize!
          #a.process_images!
          rename_batch! a if @batch_given
        end # / Tankobon::Archive
      end
    end
    
  end
end
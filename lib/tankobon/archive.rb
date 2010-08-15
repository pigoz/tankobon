require 'fileutils'

module Tankobon
  class Archive
    
    attr_accessor :filename_count
    attr_reader :directory
    
    def self.make(file, count = 0, &block)
      a = Tankobon::Archive.new(file, count)
      block.call(a)
    end
    
    def initialize(file, count = 0)
      FileUtils.mkdir_p Tankobon::WORK_PATH unless
        File.exists? Tankobon::WORK_PATH
      @directory = File.join(Tankobon::WORK_PATH, File.basename_ext(file)[0])
      FileUtils.rm_rf @directory if File.exists? @directory
      
      if File.directory? file then
        FileUtils.cp_r(file, @directory)
      else
        extract!(file)
      end
      
      @filename_count = count
    end
    
    # Extracts the input file to the \_@directory_ path
    def extract!(file)
      Dir.chdir Tankobon::WORK_PATH do
        %x[unrar -o+ x "#{file}"] if file =~ /^.*?(\.cbr|\.rar)/
        %x[unzip -d "#{File.join(Dir.pwd, File.basename_ext(file)[0])}"\
           "#{file}"] if file =~ /^.*?(\.cbz|\.zip)/
      end
    end
    
    def process_images!
      Tankobon::CLI.message "Working with files in: #{@directory}."
      Dir.xplore(@directory) do |old_file|
        new_file = File.join(File.dirname(old_file), \
                             "#{File.basename_ext(old_file)[0]}.jpg")
        process_image!(old_file, new_file)
        File.delete old_file unless old_file.eql? new_file
        Tankobon::CLI.progress("Wrote file: #{File.basename_ext(new_file)[0]}.")
      end
      Tankobon::CLI.done
    end
    
    def process_image!(old_file, new_file, opts = {})
      opts[:size] ||= '824x1200'
      opts[:colorspace] ||= 'Gray'
      
      w = %x[identify -format "%w" "#{old_file}"].to_i
      h = %x[identify -format "%h" "#{old_file}"].to_i
      
      if w > h then
        %x[convert -define jpeg:size=#{opts[:size]} "#{old_file}" -rotate 90 \
          -thumbnail '#{opts[:size]}>' -background white -gravity center \
          -extent #{opts[:size]} -colorspace #{opts[:colorspace]} \
          jpeg:"#{new_file}"
        ]
      elsif
        %x[convert -define jpeg:size=#{opts[:size]} "#{old_file}" \
          -thumbnail '#{opts[:size]}>' -background white -gravity center \
          -extent #{opts[:size]} -colorspace #{opts[:colorspace]} \
          jpeg:"#{new_file}"
        ]
      end
    end
    
    def sanitize!
      Dir.xplore(@directory) do |x|
        File.xform! x do |name|
          Tankobon::Sanitizer.sanitize(name)
        end
      end
      
      Dir.xplore(@directory) do |x|
        File.bubble_mv!(@directory, x)
      end
      
      Dir.xplore(@directory) do |x|
        File.delete x unless File.image? x
      end
      
      Dir.xplore(@directory) do |x|
        File.change_name!(x, "%05d" % @filename_count)
        @filename_count += 1
      end
    end # /def sanitize!
    
  end # /class
end # /module
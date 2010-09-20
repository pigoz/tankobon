require 'fileutils'

module Tankobon
  class Archive
    
    attr_accessor :filename_count
    attr_reader :directory
    
    acts_as_options_map
    add_default :size, '824x1200' # Kindle DX's screen size
    add_default :colorspace, 'Gray'
    
    def initialize(file, count = 0, &block)
      apply_defaults!
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
      block.arity < 1 ? self.instance_eval(&block) : block.call(self) if
        block_given?
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
    
    def process_image!(old_file, new_file)  
      w, h = %x[identify -format "%wx%h" "#{old_file}"]
        .split('x').map!{|x| x.to_i}
            
      if w > h then
        %x[convert "#{old_file}" -format jpg -rotate 90 \
          -colorspace #{get(:colorspace)} -resize #{get(:size)} \
          -background white -gravity center -extent #{get(:size)} "#{new_file}"
        ]
      elsif
        %x[convert "#{old_file}" -format jpg \
          -colorspace #{get(:colorspace)} -resize #{get(:size)} \
          -background white -gravity center -extent #{get(:size)} "#{new_file}"
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
        FileUtils.rm_rf x if File.directory? x
      end
      
      Dir.xplore(@directory) do |x|
        File.delete x unless File.image? x
      end
      
      Dir.entries(@directory).select{|x| not x =~ /^\..*$/}.each do |x|
         File.change_name!(File.join(@directory, x), "%05d" % @filename_count)
         @filename_count += 1
       end
    end # /def sanitize!
    
  end
end
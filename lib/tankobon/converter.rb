module Tankobon
  class Converter
    def initialize
      utils = [:identify, :convert]
      utils.each do |util|
        raise "Fix your ImageMagick installation, #{util} not in your path." if
          %x[which #{util}].strip == ""
      end
    end
    
    def to_proc
      method(:convert).to_proc
    end
    
    def size
      "#{width}x#{height}"
    end
    
    def will_rotate?(file)
      w, h = %x[identify -format "%wx%h" "#{file}"]
        .split('x').map{|x| x.to_i}
      w > h
    end
    
    def rotation(file)
      will_rotate?(file) ? "-rotate 90" : ""
    end
    
    def convert(file)
      %x[convert "#{file}" -format #{format} #{rotation(file)} \
        -colorspace #{colorspace} -resize #{size} -background white \
        -gravity center -extent #{size} "#{converted_name(file)}"
      ]
      clean(file)
    end
    
    protected
    def clean(file)
      File.delete(file) unless file == converted_name(file)
    end
    
    def converted_name(file)
      File.join(File.dirname(file), "#{File.splitbase[0]}.#{format}")
    end
  end
  
  class KindleDXConverter < Converter
    def width; 824; end
    def height; 1200; end
    def format; "jpg"; end
    def colorspace; "Gray"; end
  end
end
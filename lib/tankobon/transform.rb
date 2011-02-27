module Tankobon
  class Transform
    def to_proc
      method(:transform).to_proc
    end
    
    def transform(input)
      input
    end
  end
  
  class SequenceTransform  < Transform
    def initialize(seq=-1, padding=5)
      @seq = seq
      @padding = padding
    end

    def pad(num)
      "%0#{@padding}d" % num
    end

    def transform(input)
      pad(@seq += 1)
    end
  end

  class SanitizeTransform  < Transform
    def initialize(padding=5)
      @padding = padding
    end

    def pad(num)
      "%0#{@padding}d-" % num
    end

    def transform(input)
      if not input =~ /[0-9]+/ then
        "#{pad(0)}#{input}"
      else
        input.gsub(/([0-9]+)/){pad($1.to_i)}
            .gsub(/([^0-9\-]+)/){""}
            .gsub(/(\-+)/){"-"}
            .gsub(/(\-$)/){""}
            .gsub(/(^\-)/){""}
      end
    end
  end
end
module Tankobon
  class DefaultSanitizer
    
    def self.sanitize(name)
      if not name =~ /[0-9]+/ then
        "%05d-#{name}" % 0
      else
        name.gsub(/([0-9]+)/){"%05d-" % $1.to_i} \
          .gsub(/([^0-9\-]+)/){""} \
          .gsub(/(\-+)/){"-"} \
          .gsub(/(\-$)/){""}
      end
    end
    
  end
end
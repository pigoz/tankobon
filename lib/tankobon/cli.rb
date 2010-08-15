module Tankobon
  class CLI
    def self.message(string)
      puts string
    end
    
    def self.progress(progress)
      cr = "\r"           
      clear = "\e[0K"
      reset = cr + clear
      print "#{reset}"
      print "#{progress}"
      $stdout.flush
    end

    def self.done()
      cr = "\r"           
      clear = "\e[0K"
      reset = cr + clear

      print " Done.\n"
      $stdout.flush
    end
  end
end
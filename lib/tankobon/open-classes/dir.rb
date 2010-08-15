class Dir
  def self.__xplore(dir, block)
    block = Proc.new {|f| puts "Got: #{f}"} if block.nil?
    Dir.foreach(dir) do |f|
      next if f =~ /^\..*$/
      if File.directory? File.join(dir, f)
        Dir.__xplore(File.join(dir, f), block)
        block.call(File.join(dir, f))
      else
        block.call(File.join(dir, f))
      end
    end
  end
  
  def self.xplore(dir, &block)
    Dir.__xplore(dir, block)
  end
  
  def self.empty?(dir)
    entries = Dir.entries(dir)
    entries.length < 3 and entries.include? '.' and entries.include? '..'
  end
end
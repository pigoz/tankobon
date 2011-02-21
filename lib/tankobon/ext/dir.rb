class Dir
  def self.xplore(dir, &block)
    block = Proc.new {|f| puts "got: #{f}"} if block.nil?
    Dir.foreach(dir) do |f|
      next if f[0] == '.'
      if File.directory? File.join(dir, f)
        Dir.xplore(File.join(dir, f), &block)
        block.call(File.join(dir, f))
      else
        block.call(File.join(dir, f))
      end
    end
  end
  
  def self.empty?(dir)
    entries = Dir.entries(dir)
    entries.length < 3 and entries.include? '.' and entries.include? '..'
  end
end
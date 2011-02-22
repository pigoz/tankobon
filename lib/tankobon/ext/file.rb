class File
  def self.xform!(file_name, &block)
    base_name, extension = File.splitbase(file_name)
    
    block = Proc.new {|name| name} if not block_given?
    new_base_name = block.call(base_name)
    
    directory_name = File.dirname(file_name)
    
    File.rename(File.join(directory_name, "#{base_name}#{extension}"),
            File.join(directory_name, "#{new_base_name}#{extension}"))
  end
  
  def self.bubble_mv!(root_dir, file)
    return if root_dir.eql? File.dirname(file)
    new_name = "#{File.basename(File.dirname(file))}-#{File.basename(file)}"
    new_full_name = File.join(
            File.dirname(File.dirname(file)),
            new_name)
    File.rename(file, new_full_name)
    self.bubble_mv!(root_dir, new_full_name)
  end
  
  def self.change_name!(file_name, name)
    base_name = File.basename(file_name)
    base_name =~ /^(.+?)(\.[a-zA-Z0-9]+)$/
    extension = $2
    
    File.rename(file_name,
          File.join(File.dirname(file_name), "#{name}#{extension}"))
  end
  
  def self.splitbase(file)
    [File.basename(file, ".*"), File.extname(file)]
  end
  
  def self.image?(file)
    ['.jpg', '.jpeg', '.png', '.gif'].include? File.splitbase(file)[1]
  end
end
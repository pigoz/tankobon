class File
  def self.xform(file_name, &block)
    base_name, _ = File.splitbase(file_name)
    block = Proc.new {|name| name} if not block_given?
    rnbase(file_name, block.call(base_name))
  end
  
  def self.bubble_mv(root_dir, file)
    return if root_dir.eql? File.dirname(file)
    new_name = "#{File.basename(File.dirname(file))}-#{File.basename(file)}"
    new_full_name = File.join(
            File.dirname(File.dirname(file)),
            new_name)
    File.rename(file, new_full_name)
    self.bubble_mv(root_dir, new_full_name)
  end
  
  def self.rnbase(file, new_name)
    File.rename(file,
      File.join(File.dirname(file), "#{new_name}#{File.extname(file)}"))
  end
  
  def self.splitbase(file)
    [File.basename(file, ".*"), File.extname(file)]
  end
  
  def self.image?(file)
    image_extensions.include? File.extname(file).tail
  end
  
  def self.image_extensions
    ['jpg', 'jpeg', 'png', 'gif']
  end
end
module OptionsMap
  
  def self.add_option(key, default)
    @options_defaults[key.to_sym] = default
  end
  
  def set(key, value)
    @options[key.to_sym] = value
    self.send("setup_option_#{key.to_s}!".to_sym) if
      self.respond_to? "setup_option_#{key.to_s}!"
  end
  
  def get(key)
    @options[key.to_sym]
  end
  
end
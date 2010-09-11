class Object
  def self.acts_as_options_map
    extend OptionsMap::ClassMethods
    include OptionsMap::InstanceMethods
  end
end

module OptionsMap
  
  module ClassMethods

    def add_default(key, value)
      instance_variable_set(:@defaults, {}) if 
        instance_variable_get(:@defaults).nil?
      instance_variable_get(:@defaults)[key] = value
    end

  end #/ ClassMethods

  module InstanceMethods
  
    def set(key, value)
      instance_variable_set(:@options, {}) if 
        instance_variable_get(:@options).nil?
      instance_variable_get(:@options)[key.to_sym] = value
      
      instance_eval(<<-EVAL
      self.send("setup_option_#{key.to_s}!".to_sym) if
        self.respond_to? "setup_option_#{key.to_s}!"
        EVAL
      )
    end
  
    def get(key)  
      o = options
      begin
        return o.has_key?(key) ? o[key.to_sym] : nil
      rescue NoMethodError, e
        return nil
      end
    end
    
    def options
      instance_variable_get(:@options) or 
        instance_variable_set(:@options, {}) and instance_variable_get(:@options)
    end
  
    def transfer(obj, filter=nil)
      return if obj.nil? or obj.options.nil?
      result = obj.options.inject(self.options) do |r, (k, v)|
        r[k] = v if filter.nil? or filter.include? k
        r
      end
      instance_variable_set(:@options, result)
    end
    
    def defaults
      self.class.instance_variable_get(:@defaults)
    end
  
    def apply_defaults!
      self.class.instance_variable_get(:@defaults).each do |key, val|
        set key, val
      end
      self
    end
    
  end #/ InstanceMethods
  
end
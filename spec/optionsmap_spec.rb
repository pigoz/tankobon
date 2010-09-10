require 'spec_helper'

describe OptionsMap do
  
  let(:mixed_object) do
    cls = Class.new do
      acts_as_options_map
      add_default :key, :value

      def setup_option_key!
      end

    end
    
    cls.new
  end
  
  it "should have default options after calling apply_defaults!" do
    mixed_object.apply_defaults!
    mixed_object.get(:key).should eql :value
  end
  
  it "should call default options setup methods when calling apply_defaults!" do
    mixed_object.defaults.each do |key, val|
      mixed_object.should_receive "setup_option_#{key.to_s}!".to_sym
    end
    mixed_object.apply_defaults!
  end
  
end
require 'spec_helper'

describe OptionsMap do
  
  class TestKey
    acts_as_options_map
    add_default :key, :value

    def setup_option_key!
    end
  end
  
  class TestKey2
      acts_as_options_map
      add_default :key2, :value2
  end
  
  let(:key_one) { TestKey.new }
  let(:key_two) { TestKey2.new }
  
  it "should have default options after calling apply_defaults!" do
    key_one.apply_defaults!
    key_one.get(:key).should == :value
  end
  
  it "should call default options setup methods when calling apply_defaults!" do
    key_one.defaults.each do |key, val|
      key_one.should_receive "setup_option_#{key.to_s}!".to_sym
    end
    key_one.apply_defaults!
  end
  
  it "should allow to transfer properties to other objects" do
    key_one.apply_defaults!
    key_two.get(:key).should == nil
    key_two.transfer(key_one, [:key])
    key_two.get(:key).should == :value
  end
  
  it "should preserve existing properties when using transfer" do
    key_one.apply_defaults!
    key_two.apply_defaults!
    key_two.transfer(key_one)
    key_two.get(:key2).should == :value2
  end
  
end
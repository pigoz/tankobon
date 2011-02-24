require 'spec_helper'

describe Tankobon::Stageable do
  before(:each) do
    FileUtils.mkdir_p 'test'
  end
  
  after(:each) do
    FileUtils.rm_rf 'test'
  end
  
  klass = Class.new(Tankobon::Stageable) do
    def stage_root
      Pathname.new("test")
    end
  end
  
  it "should stage to the correct directory" do
    Tankobon::Stageable.new("foo").stage.should == 
      Pathname.new('~/tankobon2/foo')

    Tankobon::Stageable.new("foo.bar").stage.should == 
      Pathname.new('~/tankobon2/foo')

    Tankobon::Stageable.new("foo.bar.baz").stage.should == 
      Pathname.new('~/tankobon2/foo.bar')
  end
  
  it "should return the StagedDirectory when calling to_stage" do
    res = klass.new("foo2").to_stage
    res.class.should == Tankobon::StagedDirectory
  end
  
  it "should create the staging root directory when calling to_stage" do
    klass.new("foo2").to_stage
    File.should exists 'test'
  end
  
  it "should delete the staging directory when calling to_stage" do
    klass.new("foo2").to_stage
    File.should_not exists 'test/foo2'
  end
end
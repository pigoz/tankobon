require 'spec_helper'

describe Tankobon::Directory do
  before(:each) do
    FileUtils.mkdir_p 'test'
    FileUtils.mkdir_p 'test/foo/bar'
    FileUtils.mkdir_p 'test/foo/baz'
  end
  
  after(:each) do
    FileUtils.rm_rf 'test'
  end
  
  klass = Class.new(Tankobon::Directory) do
    def stage_root
      Pathname.new("test/stage")
    end
  end
  
  it "should return the StagedDirectory when calling to_stage" do
    res = klass.new("test/foo").to_stage
    res.class.should == Tankobon::StagedDirectory
  end
  
  it "should create the staging root directory when calling to_stage" do
    res = klass.new("test/foo").to_stage
    File.should exists 'test/stage'
  end
  
  it "should copy the provided directory to the stage when calling to_stage" do
    res = klass.new("test/foo").to_stage
    File.should exists 'test/stage/foo'
    File.should exists 'test/stage/foo/bar'
    File.should exists 'test/stage/foo/baz'
  end
  
  it "should delete the staging directory when calling to_stage" do
    FileUtils.mkdir_p 'test/stage/foo/to_delete'
    res = klass.new("test/foo").to_stage
    File.should_not exists 'test/stage/foo/to_delete'
  end
end
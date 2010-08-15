require 'spec'
require 'tankobon'
require 'fileutils'

describe Tankobon::Application, "when first created" do
  it "should create WORK_PATH directory" do
    app = Tankobon::Application.new(Dir.pwd)
    File.exists?(Tankobon::WORK_PATH).should == true
    File.directory?(Tankobon::WORK_PATH).should == true
  end
end
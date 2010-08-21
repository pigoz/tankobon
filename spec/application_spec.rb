require 'spec_helper'

describe Tankobon::Application, "when first created" do
  it "should create WORK_PATH directory" do
    app = Tankobon::Application.new
    File.should exists Tankobon::WORK_PATH
    File.should be_directory(Tankobon::WORK_PATH)
  end
end
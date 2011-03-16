require 'spec_helper'

describe Tankobon::Converter do
  before :all do
    @class = Tankobon::KindleDXConverter
    @obj = @class.new
  end
  
  it "should convert using imagemagick and clean after itself" do
    @obj.should_receive("`").with(/^convert "foo.bar"/)
    @obj.stub(:will_rotate? => true, :converted_name => "foo.baz")
    File.should_receive(:delete).with("foo.bar")
    @obj.as_null_object.convert("foo.bar")
  end
  
  it "should tell if an image is supposed to be resized" do
    @obj.should_receive("`").with(/^identify/).and_return("10x20")
    @obj.will_rotate?("foo").should be false
    @obj.should_receive("`").with(/^identify/).and_return("20x10")
    @obj.will_rotate?("foo").should be true
  end
end
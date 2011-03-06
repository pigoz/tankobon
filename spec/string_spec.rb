require 'spec_helper'

describe String do
  it "should extract the first element with head" do
    "hello".head().should == "h"
  end
  
  it "should extract the rest with tail" do
    "hello".tail().should == "ello"
  end
end
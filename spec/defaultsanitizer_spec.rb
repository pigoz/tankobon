require 'spec_helper'

describe Tankobon::DefaultSanitizer do
  it "should prepend 5 zeroes to strings with no numebers" do
    Tankobon::DefaultSanitizer.sanitize("foo").should == "00000-foo"
  end
  
  it "should 5pad numbers and concat a minus and remove everything else" do
    Tankobon::DefaultSanitizer.sanitize("Vol.3_Ch.1").should == "00003-00001"
    Tankobon::DefaultSanitizer.sanitize("-Vol.3_Ch.1").should == "00003-00001"
    Tankobon::DefaultSanitizer.sanitize("--Vol.3_Ch.1").should == "00003-00001"
    Tankobon::DefaultSanitizer.sanitize("Vol.3_Ch.1-").should == "00003-00001"
    Tankobon::DefaultSanitizer.sanitize("Vol.3_Ch.1--").should == "00003-00001"
    Tankobon::DefaultSanitizer.sanitize("-3-1-").should == "00003-00001"
  end
end
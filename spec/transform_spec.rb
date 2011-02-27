require 'spec_helper'

describe Tankobon::SanitizeTransform do
  it "should prepend 5 zeroes to strings with no numebers" do
    t = Tankobon::SanitizeTransform.new
    t.transform("foo").should == "00000-foo"
  end
  
  it "should zero pad numbers, concat a minus and remove everything else" do
    t = Tankobon::SanitizeTransform.new
    t.transform("Vol.3_Ch.1").should == "00003-00001"
    t.transform("-Vol.3_Ch.1").should == "00003-00001"
    t.transform("--Vol.3_Ch.1").should == "00003-00001"
    t.transform("Vol.3_Ch.1-").should == "00003-00001"
    t.transform("Vol.3_Ch.1--").should == "00003-00001"
    t.transform("-3-1-").should == "00003-00001"
  end
end

describe Tankobon::Transform do
  it "should return the input" do
    Tankobon::Transform.new.transform("foo").should == 'foo'
  end
  
  it "should return the transform method as a proc" do
    t = Tankobon::Transform.new
    t.to_proc.call("foo").should == 'foo'
    
    def testblock(&block); block.call('foo'); end
    testblock(&t).should == 'foo'
  end
end

describe Tankobon::SequenceTransform do
  it "should return the last integer summed by one at each call" do
    t = Tankobon::SequenceTransform.new
    t.transform("foo").should == '00000'
    t.transform("foo").should == '00001'
    t.transform("foo").should == '00002'
  end
end
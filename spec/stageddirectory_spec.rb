require 'spec_helper'

describe Tankobon::StagedDirectory do
  before :all do
    @class = Tankobon::StagedDirectory
    @upcasetx = Class.new do
      def to_proc; method(:transform).to_proc; end
      def transform(input); input.upcase; end
    end
  end
  
  it "should hold on to the stage" do
    @class.new("test/stage").stage.should == Pathname.new("test/stage")
  end

  it "should sanitize every file in the stage in a bottom up fashion" do
    FileUtils.mkdir_p("test/stage/foo/bar/baz.foo")
    FileUtils.mkdir_p("test/stage/foo/bar2/baz1.foo")
    FileUtils.mkdir_p("test/stage/foo/bar2/baz2.foo")
    tx = @upcasetx.new
    args = %w{
      test/stage/foo/bar2/baz2.foo
      test/stage/foo/bar2/baz1.foo
      test/stage/foo/bar2
      test/stage/foo/bar/baz.foo
      test/stage/foo/bar
      test/stage/foo
    }
    args.each do |arg|
      File.should_receive(:rename).with(
        arg, 
        File.join(
          File.dirname(arg),
          "#{tx.transform(File.basename(arg, '.*'))}#{File.extname(arg)}"))
    end
    @class.new("test/stage/").sanitize(@upcasetx.new)
  end
end
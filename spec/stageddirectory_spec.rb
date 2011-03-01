require 'spec_helper'

describe Tankobon::StagedDirectory do
  before :all do
    @class = Tankobon::StagedDirectory
    @upcasetx = Class.new(Tankobon::Transform) do
      def transform(input); input.upcase; end
    end
  end

  before :each do
    FileUtils.mkdir_p("test/stage/foo/bar/baz.jpg")
    FileUtils.mkdir_p("test/stage/foo/bar2/baz1.gif")
    FileUtils.mkdir_p("test/stage/foo/bar2/baz2.foo")
  end

  after :each do
    FileUtils.rm_r("test")
  end

  it "should hold on to the stage" do
    @class.new("test/stage").stage.should == Pathname.new("test/stage")
  end

  it "should sanitize every file in the stage" do
    @class.new("test/stage/").sanitize(@upcasetx.new)
    File.should exists "test/stage/FOO/BAR/BAZ.jpg"
    File.should exists "test/stage/FOO/BAR2/BAZ1.gif"
    File.should exists "test/stage/FOO/BAR2/BAZ2.foo"
  end

  it "should sanitize every file in the stage in a bottom up fashion" do
    tx = @upcasetx.new
    args = %w{
      test/stage/foo/bar2/baz2.foo
      test/stage/foo/bar2/baz1.gif
      test/stage/foo/bar2
      test/stage/foo/bar/baz.jpg
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
    @class.new("test/stage/").sanitize(tx)
  end

  it "should list images in the stage" do
    @class.new("test/stage/").images.should =~ %w{
      test/stage/foo/bar/baz.jpg
      test/stage/foo/bar2/baz1.gif
    }
  end

  it "should move images to a directory" do
    FileUtils.mkdir_p("test/stage2/")
    @class.new("test/stage/").mv_images_to("test/stage2/")
    File.should exists 'test/stage2/baz.jpg'
    File.should exists 'test/stage2/baz1.gif'
    File.should exists 'test/stage/foo/bar2/baz2.foo'
    File.should_not exists 'test/stage2/baz2.foo'
    FileUtils.rm_r("test/stage2/")
  end

  it "should move images to the stage root" do
    @class.new("test/stage/").mv_images_to_root
    File.should exists 'test/stage/baz.jpg'
    File.should exists 'test/stage/baz1.gif'
    File.should exists 'test/stage/foo/bar2/baz2.foo'
    File.should_not exists 'test/stage/baz2.foo'
  end
end

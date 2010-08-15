require 'spec'
require 'tankobon'
require 'fileutils'

describe File do
  before(:each) do
    FileUtils.mkdir_p 'test'
  end
  
  after(:each) do
    FileUtils.rm_rf 'test'
  end
  
  it "should transform files" do
    File.open("test/file_name.ext", "w")
    File.xform!("test/file_name.ext") do |file|
      file.upcase
    end
    File.exists?("test/FILE_NAME.ext").should == true
  end
  
  it "should recognize filenames and extensions" do
    File.basename_ext("test/random/path/filename.ext")[0].should == 'filename'
    File.basename_ext("test/random/path/filename.ext")[1].should == '.ext'
  end
  
  it "should move files to root directory and delete empty directories" do
    FileUtils.mkdir_p 'test/a/b'
    Dir.chdir('test/a/b') { File.open("file_name1.ext", "w").close() }
    File.bubble_mv!('test', "test/a/b/file_name1.ext")
    File.exists?('test/a-b-file_name1.ext').should == true
    File.exists?('test/a/file_name1.ext').should == false
    File.exists?('test/a/b/file_name1.ext').should == false
    File.exists?('test/a/b').should == false
    File.exists?('test/a').should == false
  end
  
  it "should change names" do
    File.open("test/file_name.ext", "w")
    File.change_name!("test/file_name.ext", "file_name2")
    File.exists?("test/file_name2.ext").should == true
  end
  
  it "should recognize images" do
    File.image?('test/random/path/image.jpeg').should == true
    File.image?('test/random/path/image.jpg').should == true
    File.image?('test/random/path/image.gif').should == true
    File.image?('test/random/path/image.png').should == true
    File.image?('test/random/path/not_image').should == false
  end
end
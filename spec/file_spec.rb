require 'spec_helper'

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
    File.should exists "test/FILE_NAME.ext"
  end
  
  it "should recognize filenames and extensions" do
    File.basename_ext("test/filename.ext").should =~ ['filename', '.ext']
  end
  
  it "should move files to root directory and delete empty directories" do
    FileUtils.mkdir_p 'test/a/b'
    Dir.chdir('test/a/b') { File.open("file_name1.ext", "w").close() }
    File.bubble_mv!('test', "test/a/b/file_name1.ext")
    
    File.should exists 'test/a-b-file_name1.ext'
    
    File.should_not exists 'test/a/b/file_name1.ext'
    File.should_not exists 'test/a/file_name1.ext'
    File.should_not exists 'test/a/b'
    File.should_not exists 'test/a'
  end
  
  it "should change names" do
    File.open("test/file_name.ext", "w")
    File.change_name!("test/file_name.ext", "file_name2")
    File.should exists "test/file_name2.ext"
  end
  
  it "should recognize images" do
    File.should be_image 'test/random/path/image.jpeg'
    File.should be_image 'test/random/path/image.jpg'
    File.should be_image 'test/random/path/image.gif'
    File.should be_image 'test/random/path/image.png'
    File.should_not be_image 'test/random/path/not_image'
  end
end
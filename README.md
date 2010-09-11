# Tankobon

Tankobon lets you batch rename, resize and change colorspace for manga scans
in order to make them optimal for consumptions on ebook readers.

Just call the binary like this:

	tankobon recipe

where recipe is a text file defining some options.

## Recipe file

Tankobon uses recipe files to define what kind of actions you want the script to
perform for you. Here is an example of a recipe file:

	clear!

	set :dir, File.expand_path('~/Monster/')

	set :files, <<-EOS
	Monster_v16.zip
	Monster_v17.zip
	EOS
	.split("\n").each {|s| s.strip!}

	set :batch, "monster" 
	#set :im, false
	
	#set :colorspace, "RGB"
	#set :size, "824x1200"

With the clear method you will remove all the content of the directory with the
final files (~/tankobon/).
	
With the set method you can give value to some properties that are used to customize the behaviour of the program. Here is a list of properties:

*  **:dir** => the directory in which the files you are processing are located
*  **:files** => the files you want to process. It supports zip, rar, cbz, cbr
and plain directories too!
*  **:batch** => activates batchmode merging all archives into one and saving
the processing result into the directory given as argument. Very handy to deal with archives that contains only one chapter.
*  **:im** => enables or disables the processing of images. If disabled the script will only rename the images.
*  **:colorspace** => the colorspace you want your images to be saved with (i.e.: "Gray", "RGB")
*  **:size** => the size you want your images to be saved with in width*x*height format
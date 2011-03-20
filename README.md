# Tankobon

Tankobon lets you batch rename, resize and change colorspace for manga scans
in order to make them optimal for consumptions on ebook readers.

Just call the binary like this:

    tankobon recipe

where recipe is a text file defining some options.

## Recipe file

Tankobon uses recipe files to define what kind of actions you want the script to
perform for you. Here is an example of a recipe file:

    files = <<-FILES
    Eden - It's An Endless World! v03 (2006) (case-DCP).zip
    Eden - It's An Endless World! v04 (2006) (case-DCP).zip
    FILES
    .split("\n").each {|s| s.strip!}
    
    with_base '~/Downloads/Eden/', files
    sanitize
    convert

Takes the listed files in the directory and sanitizes and converts them with the default sanitizer and converter.

You can choose a different converter by passing it to the convert method, you need to pass a `Tankobon::Converter` subclass. See `lib/tankobon/converter.rb` for the default `KindleDXConverter` implementation. A smart approach is inlining an anonymous subclass. For example:

    convert Class.new(Tankobon::Converter) do
      def width; 824; end
      def height; 1200; end
      def format; "png"; end
      def colorspace; "RGB"; end
    end

Issues
======
In the unlikely event that something is not working just open an issue. If you fork, fix and make a pull request we will be BFFs.
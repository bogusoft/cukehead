require 'getoptlong'
require 'fileutils'
require 'cukehead/feature_reader'
require 'cukehead/freemind_writer'

module Cukehead

  class App
    attr_accessor :features_path
    attr_accessor :mindmap_filename
    attr_accessor :source_mindmap_filename
    attr_accessor :do_overwrite
    attr_reader :errors

    def initialize
      @command = ''
      @features_path = File.join(Dir.getwd, 'features')
      @mindmap_filename = File.join(Dir.getwd, 'mm', 'cukehead-output.mm')
      @source_mindmap_filename = ''
      @reader = nil
      @do_overwrite = false
      @errors = []
    end


    def get_source_xml
      if @source_mindmap_filename.empty?
        nil
      else
        text = nil
        File.open(@source_mindmap_filename, 'r') {|f|
          text = f.readlines
        }
        text.join
      end
    end


    def read_features
      @reader = FeatureReader.new get_source_xml
      search_path = File.join @features_path, '*.feature'
      puts "Reading " + search_path
      Dir[search_path].each {|filename|
        File.open(filename, 'r') {|f|
          text = f.readlines
          @reader.extract_features filename, text #unless text.nil?
        }
      }
    end


    def write_mindmap
      if @reader.nil?
        @errors << "No features to write (perhaps read_features has not been called)"
        return false
      end
      if @do_overwrite != true and File.exists? @mindmap_filename
        @errors << "File already exists: " + @mindmap_filename
        return false
      end
      dir = File.dirname(@mindmap_filename)
      FileUtils.mkdir_p(dir) unless File.directory? dir
      writer = FreemindWriter.new
      puts "Writing " + @mindmap_filename
      writer.write_mm @mindmap_filename, @reader.freemind_xml
      return true
    end


    def get_options
      mm = ''
      fp = ''
      opts = GetoptLong.new(
        ['--help', '-h', GetoptLong::NO_ARGUMENT],
        ['--overwrite', '-o', GetoptLong::NO_ARGUMENT],
        ['--mm-filename', '-m', GetoptLong::REQUIRED_ARGUMENT],
        ['--features-path', '-p', GetoptLong::REQUIRED_ARGUMENT],
        ['--source-mm', '-s', GetoptLong::REQUIRED_ARGUMENT]
      )
      opts.each do |opt, arg|
        case
          when opt == '--help' then @command = 'help'
          when opt == '--overwrite' then @do_overwrite = true
          when opt == '--mm-filename' then mm = arg
          when opt == '--features-path' then fp = arg
          when opt == '--source-mm' then @source_mindmap_filename = arg
        end
      end

      ARGV.each do |a|
        if a == 'map'
          @command = 'map' if @command == ''
        else
          # If features path or mindmap file name was not specified
          # in option arguments then infer them from any remaining
          # command line arguments. Specific option takes precidence.
          fp = a if fp.empty? and a.slice(-9, 9) == '/features'
          mm = a if mm.empty? and a.slice(-3, 3) == '.mm'
        end
      end

      @features_path = fp unless fp.empty?
      @mindmap_filename = mm unless mm.empty?
    end


    def show_errors
      unless @errors.empty?
        puts "Errors:"
        @errors.each {|err| puts err}
      end
    end


    def show_help
      puts <<xxx

Usage: cukehead command [options]

command:  
  map
      Read features and create a FreeMind mind map file.

options:
  -o or --overwrite
      Overwrite existing output file.

  -m FILENAME or --mm-filename FILENAME
      Specify name of output file (default is mm/cukehead-output.mm).

  -p PATH or --features-path PATH
      Specify directory containing feature files to read
      (default is directory named 'features' in current directory).

  -s FILENAME or --source-mm FILENAME
      Specify a FreeMind mind map file to use as a template for creating
      the output file. If the template contains a node with the text
      'Cucumber features:' then the feature nodes will be inserted there.

xxx
    end


    def run
      get_options
      if @command == 'map'
        read_features
        write_mindmap
        show_errors
      else
        show_help
      end
    end

  end
  
end
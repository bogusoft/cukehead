require 'getoptlong'
require 'fileutils'
require 'cukehead/feature_reader'
require 'cukehead/freemind_writer'
require 'cukehead/freemind_reader'
require 'cukehead/feature_writer'

module Cukehead

  # The Cukehead::App class is responsible for responding to
  # command line arguments and providing the main functionality
  # of the cukehead application.
  #
  class App
    attr_accessor :features_path
    attr_accessor :mindmap_filename
    attr_accessor :mindmap_template_filename
    attr_accessor :do_overwrite
    attr_reader :errors
    attr_reader :feature_reader

    def initialize
      @features_path = File.join(Dir.getwd, 'features')
      @mindmap_filename = File.join(Dir.getwd, 'mm', 'cukehead-output.mm')
      @mindmap_template_filename = ''
      @feature_reader = nil
      @mindmap_reader = nil
      @do_overwrite = false
      @errors = []
    end


    # Main entry point for executing the cukehead application.
    # Responsible for responding to the command line arguments.
    #
    def run
      get_options
      if @errors.empty?
        if @command == 'map'
          read_features
          write_mindmap
          show_errors
        elsif @command == 'cuke'
          read_mindmap
          write_features
          show_errors
        else
          show_help
        end
      else
        show_errors
      end
    end

  private

    def read_features
      @feature_reader = FeatureReader.new get_source_xml
      search_path = File.join @features_path, '*.feature'
      puts "Reading #{search_path}"
      Dir[search_path].sort.each do |filename|
        File.open(filename, 'r') do |f|
          text = f.readlines
          @feature_reader.extract_features filename, text #unless text.nil?
        end
      end
    end


    def write_mindmap
      if @feature_reader.nil?
        @errors << "No features to write (perhaps read_features has not been called)"
        return false
      end
      if @do_overwrite != true and File.exists? @mindmap_filename
        @errors << "File already exists: #{@mindmap_filename}"
        return false
      end
      dir = File.dirname(@mindmap_filename)
      FileUtils.mkdir_p(dir) unless File.directory? dir
      writer = FreemindWriter.new
      puts "Writing " + @mindmap_filename
      writer.write_mm @mindmap_filename, @feature_reader.freemind_xml
      return true
    end


    def default_mm_search_path
      File.join(Dir.getwd, 'mm', '*.mm')
    end


    def read_mindmap
      puts "Reading #{@mindmap_filename}"      
      begin
        @mindmap_reader = FreemindReader.new @mindmap_filename
      rescue => ex
        @errors << 'Error in read_mindmap: ' + ex.message
      end
    end


    def write_features
      if @mindmap_reader.nil?
        @errors << "No mind map data."
        return false
      end
      begin
        writer = FeatureWriter.new
        writer.output_path = @features_path
        writer.overwrite = @do_overwrite
        features = @mindmap_reader.get_features
        if features.empty?
          @errors << 'No Cucumber features found in the mind map file.'
          @errors << 'Mind map may be missing a "Cucumber features:" node.'
        else
          features.each_key {|filename| puts "Writing #{File.join(@features_path, filename)}"}
          writer.write_features features
          @errors << writer.errors unless writer.errors.empty?
        end
      rescue => ex
        @errors << 'Error in write_features: ' + ex.message
      end
    end


    def get_source_xml
      if @mindmap_template_filename.empty?
        nil
      else
        text = nil
        File.open(@mindmap_template_filename, 'r') do |f|
          text = f.readlines
        end
        text.join
      end
    end


    def default_mm_file
      Dir[default_mm_search_path].first
    end


    def get_options
      mm = ''
      fp = ''
      begin
        opts = GetoptLong.new(
          ['--help', '-h', GetoptLong::NO_ARGUMENT],
          ['--overwrite', '-o', GetoptLong::NO_ARGUMENT],
          ['--mm-filename', '-m', GetoptLong::REQUIRED_ARGUMENT],
          ['--features-path', '-f', GetoptLong::REQUIRED_ARGUMENT],
          ['--source-mm', '-s', GetoptLong::REQUIRED_ARGUMENT]
        )
        opts.each do |opt, arg|
          case
            when opt == '--help' then @command = 'help'
            when opt == '--overwrite' then @do_overwrite = true
            when opt == '--mm-filename' then mm = arg
            when opt == '--features-path' then fp = arg
            when opt == '--source-mm' then @mindmap_template_filename = arg
          end
        end
      rescue => ex
        @errors << ex.message
      end

      # If features path or mindmap file name was not specified
      # in option arguments then infer them from any remaining
      # command line arguments. Specific option takes precidence.
      ARGV.each do |a|
        if a == 'map'
          @command = 'map' unless @command 
        elsif a == 'cuke'
          @command = 'cuke' unless @command 
        elsif a.slice(-9, 9) == '/features'
          fp = a if fp.empty?
        elsif a.slice(-3, 3) == '.mm'
          mm = a if mm.empty?
        else
          @errors << "Unknown command or option: #{a}"
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
      Read Cucumber feature files and create a FreeMind mind map file.

  cuke
      Read a FreeMind mind map file and create Cucumber feature files.

options:
  -h or --help
      Show this help message.

  -o or --overwrite
      Overwrite existing output file(s).

  -m FILENAME or --mm-filename FILENAME
      map: Name of output file (default is mm/cukehead-output.mm).

      cuke: Name of mind map file containing Cucumber features.

  -f PATH or --features-path PATH
      map: Directory containing feature files to read (default is directory
      named 'features' in current directory).

      cuke: Directory feature files will be written to.

  -s FILENAME or --source-mm FILENAME
      map: FreeMind mind map file to use as a template for creating
      the output file. If the template contains a node with the text
      'Cucumber features:' then the feature nodes will be inserted there.

xxx
    end


  end
  
end

require 'getoptlong'
require 'fileutils'
require 'cukehead/feature_reader'
require 'cukehead/freemind_writer'

module Cukehead

  class App
    attr_accessor :features_path
    attr_accessor :mindmap_filename
    attr_accessor :do_overwrite
    attr_reader :errors

    def initialize
      @features_path = File.join(Dir.getwd, 'features')
      @mindmap_filename = File.join(Dir.getwd, 'mm', 'cukehead.mm')
      @reader = nil
      @do_overwrite = false
      @errors = []
    end


    def read_features
      @reader = FeatureReader.new
      search_path = File.join @features_path, '*.feature'
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
      writer.write_mm @mindmap_filename, @reader.freemind_xml
      return true
    end


    def get_options
      mm = ''
      fp = ''
      opts = GetoptLong.new(
        ['--overwrite', '-o', GetoptLong::NO_ARGUMENT],
        ['--mm-filename', '-m', GetoptLong::REQUIRED_ARGUMENT],
        ['--features-path', '-p', GetoptLong::REQUIRED_ARGUMENT]
      )
      opts.each do |opt, arg|
        case
          when opt == '--overwrite' then @do_overwrite = true
          when opt == '--mm-filename' then mm = arg
          when opt == '--features-path' then fp = arg
        end
      end

      # If features path or mindmap file name was not specified
      # in option arguments then infer them from any remaining
      # command line arguments. Specific option takes precidence.
      ARGV.each do |a|
        fp = a if fp.empty? and a.slice(-9, 9) == '/features'
        mm = a if mm.empty? and a.slice(-3, 3) == '.mm'
      end

      @features_path = fp unless fp.empty?
      @mindmap_filename = mm unless mm.empty?
    end


    def run
      get_options
      read_features
      write_mindmap
    end

  end
  
end
module Cukehead

  class App
    attr_accessor :features_path
    attr_accessor :mindmap_filename

    def initialize
      @features_path = File.join(Dir.getwd, 'features')
      @mindmap_filename = File.join(Dir.getwd, 'mm', 'cukehead.mm')
      @reader = nil
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
      dir = File.dirname(@mindmap_filename)
      FileUtils.mkdir_p(dir) unless File.directory? dir
      writer = FreemindWriter.new
      writer.write_mm @mindmap_filename, @reader.freemind_xml
    end


    def run

    end

  end
  
end
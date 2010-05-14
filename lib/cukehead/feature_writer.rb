module Cukehead

  class FeatureWriter
    attr_accessor :output_path

    
    def initialize
      @output_path = File.join(Dir.getwd, 'features')
    end


    def write_features(features)
      FileUtils.mkdir_p(@output_path) unless File.directory? @output_path
      features.each {|fn, text|
        filename = File.join(@output_path, fn)
        File.open(filename, 'w') {|f| f.write(text)}
      }
    end


  end

end

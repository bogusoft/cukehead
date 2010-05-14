module Cukehead

  class FeatureWriter
    attr_accessor :output_path
    attr_accessor :overwrite
    attr_reader :errors

    
    def initialize
      @output_path = File.join(Dir.getwd, 'features')
      @overwrite = false
      @errors = []
    end


    def write_features(features)
      # Param features must be a hash of filename => featuretext.
      FileUtils.mkdir_p(@output_path) unless File.directory? @output_path
      ok = true
      unless @overwrite
        features.each {|fn, text|
          filename = File.join(@output_path, fn)
          if File.exists? filename
            @errors << "Exists: #{filename}"
            ok = false
          end
        }
      end
      if ok
        features.each {|fn, text|
          filename = File.join(@output_path, fn)
          File.open(filename, 'w') {|f| f.write(text)}
        }
      end
    end

  end

end

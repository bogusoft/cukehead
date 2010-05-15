require 'rexml/document'

module Cukehead

  class FreemindReader
    
    def initialize(filename)
      @mmdoc = nil
      @features_node = nil
      File.open(filename, "r") {|f|
        xml = f.read
        @mmdoc = REXML::Document.new(xml)
        @features_node = cucumber_features_node
      }
      @features = []
    end

  end

end
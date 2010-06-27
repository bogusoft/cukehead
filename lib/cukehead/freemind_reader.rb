require 'rexml/document'
require 'cukehead/feature_node'

module Cukehead

  class FreemindReader
    
    def initialize(filename = nil)
      @mmdoc = nil
      read_file filename unless filename.nil?
    end

    # Loads the text from the specified file into a new REXML::Document
    #
    def read_file(filename)
      File.open(filename, "r") {|f| load_xml(f.read)}
    end

    # Loads the given XML string into a new REXML::Document.
    #
    def load_xml(xml)
      @mmdoc = REXML::Document.new(xml)
    end
    
    # Returns the first <i>REXML::Element</i> containing a TEXT attribute 
    # that matches 'Cucumber features:'.
    # Returns nil if no match is found.
    #
    def cucumber_features_node
      # XPath is case-sensitive so I'm using the translate function as
      # described in a blog post titled "Performing a Case In-sensitive
      # search in an XML Document" by Harish Ranganathan
      # http://geekswithblogs.net/ranganh/archive/2005/09/12/53520.aspx
      #
      # There may be functions in XPath version 2 that provide a better way
      # to do case-insensitive search but as of this writing REXML only
      # implements XPath 1.0.
      #
      # Because the search is for a specific string, only those characters
      # need translated to lower case.
      REXML::XPath.first(@mmdoc, '//node[translate(attribute::TEXT, "CUMBERFATS", "cumberfats")="cucumber features:"]')
    end


    def get_feature_nodes
      node = cucumber_features_node
      feature_nodes = []
      node.each {|e|
        if e.is_a? REXML::Element
          text = e.attributes["TEXT"]
          feature_nodes << FeatureNode.new(e) if text =~ /^feature:.*/i
        end
      } unless node.nil?
      feature_nodes
    end


    def get_features
      result = Hash.new
      feature_nodes = get_feature_nodes
      feature_nodes.each {|feature|
        result[feature.filename] = feature.to_text
      }
      result
    end

  end

end
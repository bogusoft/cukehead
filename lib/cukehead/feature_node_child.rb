require 'rexml/document'
require 'cukehead/feature_node_tags'

module Cukehead

  # Responsible for extracting the contents of a mind map node representing
  # a sub-section of a feature (such as a Background or Scenario) and
  # providing it as text for a feature file.
  #
  class FeatureNodeChild

    # Extracts the feature section described in the given node.
    # ===Parameters
    # <tt>node</tt> - REXML::Element
    #
    def initialize(node)
      @description = []
      @tags = FeatureNodeTags.new
      @title = node.attributes["TEXT"]
      from_mm_node node
    end

    
    # Returns the title, tags, and descriptive text extracted from the
    # mind map as a string of text formatted for output to a feature file.
    # ===Parameters
    # <tt>pad</tt> - String of whitespace to use to indent the section.
    #
    def to_text(pad)
      s = "\n"
      @description.each {|d| s += pad + "  " + d + "\n"}
      pad + @tags.to_text(pad) + @title + s
    end
    
    private
    
    # Extracts tags and descriptive text from child nodes of the given node.
    # ===Parameters
    # <tt>node</tt> - REXML::Element
    #
    def from_mm_node(node)
      if node.has_elements?
        node.elements.each do |e|
          text = e.attributes["TEXT"]
          unless text.nil?
            if text =~ /^Tags:*/i
              @tags.from_text text
            else
              @description << text
            end
          end
        end
      end
    end
    
  end

end
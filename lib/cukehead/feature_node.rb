require 'rexml/document'
require 'cukehead/feature_node_tags'
require 'cukehead/feature_node_child'

module Cukehead

  # Responsible for extracting the attributes of a feature from a XML node
  # (REXML::Element) and providing those attributes as text in Cucumber
  # feature file format.
  #
  class FeatureNode

    # Extracts the attributes of a feature from a mind map node.
    # ===Parameters
    # <tt>node</tt> - REXML::Element
    #
    def initialize(node)
      @feature_filename = ""
      @description = []
      @backgrounds = []
      @scenarios = []
      @tags = FeatureNodeTags.new
      @title = node.attributes["TEXT"]
      from_mm_node node
    end

    
    # Returns the feature title as a string suitable for use as a file name.
    #
    def title_as_filename
      result = ''
      t = @title.strip.gsub(/^feature:/i, ' ').strip
      t.downcase.gsub(/\ /, '_').scan(/[_0-9a-z]/) {|c| result << c }
      result + '.feature'
    end


    # Returns a string that is either the file name  given explititly in the
    # mind map or a file name constructed from the feature title.
    #
    def filename
      if @feature_filename.empty?
        title_as_filename
      else
        @feature_filename
      end
    end

    
    # Returns the file name extracted from the given text where the format
    # is '<i>[file: filename.feature]</i>' or '<i>[file: "filename.feature"]</i>'.
    #
    def filename_from(text)
      a = text.index ':'
      if a.nil? then return "" end
      b = text.index ']'
      if b.nil? then return "" end
      a += 1
      if a > 5 and b > a
        text.slice(a, b-a).delete('"').strip
      else
        ""
      end
    end


    # Returns a string containing the attributes of this feature as text
    # formatted for output to a Cucumber feature file.
    #
    def to_text
      text = @tags.to_text('') + @title + "\n"
      pad = "  "
      @description.each {|line| text += pad + line + "\n"}
      text += "\n"
      @backgrounds.each {|background| text += background.to_text(pad) + "\n"}
      @scenarios.each {|scenario| text += scenario.to_text(pad) + "\n"}
      text
    end


    private


    # ===Parameters
    # <tt>node</tt> - REXML::Element
    #
    def from_mm_node(node)
      if node.has_elements?
        node.elements.each do |e|
        text = e.attributes["TEXT"]
          if !text.nil?
            case text
              when /^Background:*/i
                @backgrounds << FeatureNodeChild.new(e)
              when /^Scenario:*/i
                @scenarios << FeatureNodeChild.new(e)
              when /^\[file:.*/i
                @feature_filename = filename_from text
              when /^Tags:*/i
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
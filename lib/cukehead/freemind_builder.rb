require 'rexml/document'

class FreemindBuilder

  #DEFAULT_XML = "<map version=\"0.7.1\">\n<node TEXT=\"New mind map\">\n</node>\n</map>"
  DEFAULT_XML = "<map version='0.7.1'><node TEXT='New mind map'></node></map>"
  COLOR_SYSTEM = '#a1a1a1'

  def initialize(mm_xml = nil)
    if mm_xml.nil? 
      @mmdoc = REXML::Document.new(DEFAULT_XML)
    else
      @mmdoc = REXML::Document.new(mm_xml)
    end
    @features_path = nil    
  end
  
  def new_node_element(text, color = "", folded = false)
    e = REXML::Element.new "node"
    e.add_attribute 'TEXT', text
    e.add_attribute 'COLOR', color if color.length > 0
    e.add_attribute 'FOLDED', 'true' if folded
    e
  end

  def add_cucumber_features_node
    node = @mmdoc.root.elements[1]
    e = new_node_element "Cucumber features:"
    node.add_element e
    #$stderr.puts "DEBUG: add_cucumber_features_node: " + e.to_s
    return e
  end

  def cucumber_features_node
    node = REXML::XPath.first(@mmdoc, '//node[attribute::TEXT="Cucumber features:"]')
    if node == nil
      add_cucumber_features_node
    else
      node
    end
  end

  def features_path_text
    '[path: ' + @features_path + ']'
  end

  def add_features_path(filename)
    @features_path = File.dirname(File.expand_path(filename))
    e = new_node_element features_path_text, COLOR_SYSTEM
    e.add_attribute 'LINK', @features_path
    @features_node.add_element e
  end

  
  
  def add_feature(feature, filename)
    # *!*
  end
  
  def xml
    @mmdoc.to_s
  end
end


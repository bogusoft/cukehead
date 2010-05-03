require 'rexml/document'

class FreemindBuilder

  #DEFAULT_XML = "<map version=\"0.7.1\">\n<node TEXT=\"New mind map\">\n</node>\n</map>"
  DEFAULT_XML = "<map version='0.7.1'><node TEXT='New mind map'></node></map>"
  COLOR_FEATURE = '#0000ff'
  COLOR_BACKGROUND = '#ff0000'
  COLOR_SCENARIO_1 = '#3d9140'
  COLOR_SCENARIO_2 = '#cd8500'
  COLOR_TAGS = '#B452CD'
  COLOR_SYSTEM = '#a1a1a1'
  FOLD_FEATURE = true
  FOLD_BACKGROUND = true
  FOLD_SCENARIO = true

  def initialize(mm_xml = nil)
    if mm_xml.nil? 
      @mmdoc = REXML::Document.new(DEFAULT_XML)
    else
      @mmdoc = REXML::Document.new(mm_xml)
    end
    @features_path = nil  
    @features_node = cucumber_features_node
  end
  
  def new_node_element(text, color = "", folded = false)
    e = REXML::Element.new "node"
    e.add_attribute 'TEXT', text
    e.add_attribute 'COLOR', color if color.length > 0
    e.add_attribute 'FOLDED', 'true' if folded
    e
  end

  def new_italic_font_element
    # <font ITALIC="true" NAME="SansSerif" SIZE="12"/>
    e = REXML::Element.new "font"
    e.add_attribute 'ITALIC', "true"
    e.add_attribute 'NAME', "SansSerif"
    e.add_attribute 'SIZE', "12"
    e
  end

  def new_bold_font_element
    e = REXML::Element.new "font"
    e.add_attribute 'BOLD', "true"
    e.add_attribute 'NAME', "SansSerif"
    e.add_attribute 'SIZE', "12"
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

  def feature_filename_text(filename)
    '[file: ' + File.basename(filename) + ']'
  end

  def add_features_path(filename)
    @features_path = File.dirname(File.expand_path(filename))
    e = new_node_element features_path_text, COLOR_SYSTEM
    e.add_attribute 'LINK', @features_path
    @features_node.add_element e
  end
  
  def new_feature_node(title)
    e = new_node_element title.strip, COLOR_FEATURE, FOLD_FEATURE
    e.add_element new_bold_font_element
    #new_node = @features_node.add_element e
    @features_node.add_element e
  end

  def add_feature(section, filename)
    add_features_path(filename) if @features_path.nil?
    new_node = new_feature_node section.title
    e = new_node_element feature_filename_text(filename), COLOR_SYSTEM
    e.add_attribute 'LINK', filename
    new_node.add_element e
    unless section.tags.empty? new_node.add_element(
      new_node_element('Tags: ' + tags.join(' '), COLOR_TAGS)
    )
    section.lines.each do |line|
      el = new_node_element line.strip, COLOR_FEATURE
      if line =~ /^\ *(As\ |In\ |I\ ).*$/
        el.add_element new_bold_font_element
      else  
        el.add_element new_italic_font_element
      end
      new_node.add_element el
    end
    @current_feature = new_node
  end
  
  def xml
    @mmdoc.to_s
  end
end


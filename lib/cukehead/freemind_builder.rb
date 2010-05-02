require 'rexml/document'

class FreemindBuilder

  #DEFAULT_XML = "<map version=\"0.7.1\">\n<node TEXT=\"New mind map\">\n</node>\n</map>"
  DEFAULT_XML = "<map version='0.7.1'><node TEXT='New mind map'></node></map>"

  def initialize(mm_xml = nil)
    if mm_xml.nil? 
      @mmdoc = REXML::Document.new(DEFAULT_XML)
    else
      @mmdoc = REXML::Document.new(mm_xml)
    end
  end
  
  def xml
    @mmdoc.to_s
  end
end


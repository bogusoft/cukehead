require 'test/unit'
require File.join(File.dirname(__FILE__), '../lib/cukehead/freemind_builder')

class TestFreemindBuilder < Test::Unit::TestCase  
  def test_creates_XML_for_empty_FreeMind_mind_map_by_default
    builder = FreemindBuilder.new
    xml = builder.xml
    expect = "<map version='0.7.1'><node TEXT='New mind map'><node TEXT='Cucumber features:'/></node></map>"
    assert_equal expect, xml
  end
end

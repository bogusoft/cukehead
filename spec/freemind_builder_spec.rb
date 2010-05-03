require File.dirname(__FILE__) + '/spec_helper'
require 'cukehead/feature_section'
require 'cukehead/freemind_builder'

describe "FreemindBuilder" do
  before do
    @builder = FreemindBuilder.new
    #puts "BEFORE"
  end
  
  it "should specify a XML node for Cucumber features" do
    node = @builder.cucumber_features_node
    node.should be_a REXML::Element    
    node.to_s.should match /.*Cucumber features:.*/
  end
  
  it "should use an existing node for Cucumber features if one exists" do
    mm = "<map version='0.7.1'><node TEXT='mind map'><node TEXT='A child node'><node TEXT='Cucumber features:'></node></node></node></map>"
    b = FreemindBuilder.new mm
    node = b.cucumber_features_node
    node.should be_a REXML::Element
    xml = b.xml
    doc = REXML::Document.new(xml)
    doc.should_not be_nil
    #puts doc.to_s
    #node = REXML::XPath.first(@doc, '//node[attribute::TEXT="A child node"]')
    #node.should_not be_nil
    #child = node.elements.first
    #child.to_s.should match /.*Cucumber features:.*/
  end
  
  it "should save the path to the features directory" do
    #builder = FreemindBuilder.new
    filename = '/tmp/some.feature'
    @builder.add_features_path filename
    @builder.features_path_text.should match /^\[path:.*some\.feature\]/
  end
  
  it "should create new XML node element with text, color, and folded attributes" do
    #builder = FreemindBuilder.new
    text = "Test node"
    color = "blue"
    folded = true
    node = @builder.new_node_element(text, color, folded)
    node.should be_a REXML::Element
    node.to_s.should match "<node FOLDED='true' TEXT='Test node' COLOR='blue'/>"
  end
  
  it "should add a feature and specify the name of the file it is from" do
    feature = FeatureSection.new
    feature.title = "Feature: Test feature"
    filename = "test.feature"
    #builder = FreemindBuilder.new
    @builder.add_feature feature, filename
    @builder.xml.should match /.*Test feature.*/ 
  end
end

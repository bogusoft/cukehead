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
    node = REXML::XPath.first(doc, '//node[attribute::TEXT="A child node"]')
    node.should_not be_nil
    child = node.elements.first
    #puts child.to_s
    child.to_s.should match /.*Cucumber features:.*/
  end
  
  it "should save the path to the features directory" do
    #builder = FreemindBuilder.new
    filename = '/tmp/features/some.feature'
    @builder.add_features_path filename
    @builder.features_path_text.should match "[path: /tmp/features]"
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
    @builder.add_feature feature, filename
    @builder.xml.should match /.*Test feature.*/ 
  end
  
  it "should include lines and tags attributes in the XML output" do
    feature = FeatureSection.new "Feature: Test feature"
    feature.add_line "As a test"
    feature.add_line "I want to add some lines of text"
    feature.add_line "In order to make sure I can"
    feature.tags << "@test"
    @builder.add_feature feature, "test.feature"
    @builder.xml.should match /.*Test feature.*\@test.*As a test.*/ 
  end
  
  it "should add a Background section to the current feature" do
    feature = FeatureSection.new "Feature: Test feature"
    @builder.add_feature feature, "test.feature"
    bg = FeatureSection.new "Background:"
    bg.add_line "Given this thingy"
    bg.add_line "And that other thingy"
    bg.tags << "@test"    
    @builder.add_background bg
    @builder.xml.should match /.*Test feature.*Background:.*\@test.*thingy.*/     
  end
  
  it "should add a Scenario section to the current feature" do
    feature = FeatureSection.new "Feature: Test feature"
    @builder.add_feature feature, "test.feature"
    sc = FeatureSection.new "Scenario: Test a scenario"
    sc.add_line "Given I am a scenario section"
    sc.add_line "When I am added to a FreemindBuilder"
    sc.add_line "Then I should see myself in the output."
    sc.tags << "@test"    
    @builder.add_scenario sc
    @builder.xml.should match /.*Test feature.*Scenario:.*\@test.*in the output.*/     
  end
  
end

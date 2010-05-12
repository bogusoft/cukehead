require File.dirname(__FILE__) + '/spec_helper'
require 'cukehead/feature_part'
require 'cukehead/freemind_builder'

module Cukehead
  
  describe "FreemindBuilder" do
    before do
      @builder = FreemindBuilder.new
    end

    it "should specify a XML node for Cucumber features" do
      node = @builder.cucumber_features_node
      node.should be_a REXML::Element
      node.to_s.should match /.*Cucumber features:.*/
    end

    it "should use an existing node labelled 'Cucumber features:' if there is one" do
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
      child.to_s.should match /.*Cucumber features:.*/
    end

    it "should save the path to the features directory" do
      filename = '/tmp/features/some.feature'
      @builder.add_features_path filename
      @builder.features_path_text.should match "[path: /tmp/features]"
    end

    it "should create new XML node element with text, color, and folded attributes" do
      text = "Test node"
      color = "blue"
      folded = true
      node = @builder.new_node_element(text, color, folded)
      node.should be_a REXML::Element
      node.to_s.should match "<node FOLDED='true' TEXT='Test node' COLOR='blue'/>"
    end

    it "should add a feature and specify the name of the file it is from" do
      feature = FeaturePart.new
      feature.title = "Feature: Test feature"
      filename = "test.feature"
      @builder.add_feature feature, filename
      @builder.xml.should match /.*Test feature.*/
    end

    it "should include lines and tags attributes in the XML output" do
      feature = FeaturePart.new "Feature: Test feature"
      feature.add_line "As a test"
      feature.add_line "I want to add some lines of text"
      feature.add_line "In order to make sure I can"
      feature.tags << "@test"
      @builder.add_feature feature, "test.feature"
      @builder.xml.should match /.*Test feature.*\@test.*As a test.*/
    end

    it "should add a Background part to the current feature" do
      feature = FeaturePart.new "Feature: Test feature"
      @builder.add_feature feature, "test.feature"
      bg = FeaturePart.new "Background:"
      bg.add_line "Given this thingy"
      bg.add_line "And that other thingy"
      bg.tags << "@test"
      @builder.add_background bg
      @builder.xml.should match /.*Test feature.*Background:.*\@test.*thingy.*/
    end

    it "should add a Scenario section to the current feature" do
      feature = FeaturePart.new "Feature: Test feature"
      @builder.add_feature feature, "test.feature"
      sc = FeaturePart.new "Scenario: Test a scenario"
      sc.add_line "Given I am a scenario part"
      sc.add_line "When I am added to a FreemindBuilder"
      sc.add_line "Then I should see myself in the output."
      sc.tags << "@test"
      @builder.add_scenario sc
      @builder.xml.should match /.*Test feature.*Scenario:.*\@test.*in the output.*/
    end

  end

end

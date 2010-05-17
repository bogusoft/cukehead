require File.dirname(__FILE__) + '/spec_helper'
require 'rexml/document'
require 'cukehead/feature_node'

module Cukehead

  describe "FeatureNodeTags" do

    it "extracts tags from text" do
      @fntags = FeatureNodeTags.new
      text = "tags: @tag1 @tag2"
      @fntags.from_text text
      @fntags.should_not be_nil
    end

    it "returns tags as a string padded for output" do
      @fntags = FeatureNodeTags.new
      text = "tags: @tag1 @tag2"
      @fntags.from_text text
      @fntags.to_text('    ').should eql "    @tag1 @tag2\n"
    end

  end
  

  describe "FeatureNodeChild" do

    before do
      @xml = $testing_freemind_data
    end

    it "populates itself from a FreeMind XML document node that is a child of a feature node" do
      doc = REXML::Document.new @xml
      node = REXML::XPath.first doc, '//node[attribute::TEXT="Scenario: Sites List"]'
      feature_node_child = FeatureNodeChild.new node
      feature_node_child.should_not be_nil
    end

    it "returns a text representation of itself padded for output to a Cucumber feature file" do
      doc = REXML::Document.new @xml
      node = REXML::XPath.first doc, '//node[attribute::TEXT="Scenario: Sites List"]'
      feature_node_child = FeatureNodeChild.new node
      feature_node_child.to_text('  ').should match /^\ \ Scenario:.*/m
    end

  end


  describe "FeatureNode" do

    before do
      @xml = <<xxx
<map>
  <node TEXT='Cucumber features:'>
    <node TEXT='Feature: Test feature'>
      <node TEXT='As a test'/>
      <node TEXT='I want to pass'/>
    </node>
  </node>
</map>
xxx

      @xml_with_filename = <<xxx
<map>
  <node TEXT='Cucumber features:'>
    <node TEXT='Feature: Test feature'>
      <node TEXT='[file: my_filename.feature]'/>
    </node>
  </node>
</map>
xxx

      doc = REXML::Document.new @xml
      node = REXML::XPath.first doc, '//node[attribute::TEXT="Feature: Test feature"]'
      @feature_node = FeatureNode.new(node)
    end

    it "populates itself from a XML document node describing a Cucumber feature" do
      doc = REXML::Document.new @xml
      node = REXML::XPath.first doc, '//node[attribute::TEXT="Feature: Test feature"]'
      feat = FeatureNode.new(node)
      feat.should_not be_nil
    end

    it "returns the file name for the feature as specified in the document" do
      doc = REXML::Document.new @xml_with_filename
      node = REXML::XPath.first doc, '//node[attribute::TEXT="Feature: Test feature"]'
      feat = FeatureNode.new(node)
      feat.filename.should eql 'my_filename.feature'
    end

    it "creates a file name if none was specified based on the feature title" do
      doc = REXML::Document.new @xml
      node = REXML::XPath.first doc, '//node[attribute::TEXT="Feature: Test feature"]'
      feat = FeatureNode.new(node)
      feat.filename.should eql 'test_feature.feature'
    end

    it "has a method to return a file name from text in the mind map specifying the file name" do
      @feature_node.filename_from('').should eql ''
      @feature_node.filename_from('[file: filename.feature]').should eql 'filename.feature'
      @feature_node.filename_from('[file: "filename.feature"]').should eql 'filename.feature'
      @feature_node.filename_from('[file:filename.feature]').should eql 'filename.feature'
      @feature_node.filename_from('[file:"filename.feature"]').should eql 'filename.feature'
      @feature_node.filename_from('[ File:  "  filename.feature  " ] ').should eql 'filename.feature'
    end


    it "returns itself in Cucumber feature file format as a single string of text" do
      @feature_node.to_text.should eql "Feature: Test feature\n  As a test\n  I want to pass\n\n"
    end

  end

end

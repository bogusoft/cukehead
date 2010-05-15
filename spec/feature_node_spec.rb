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
      @fntags.to_text('    ').should match '    @tag1 @tag2'
    end

  end
  

  describe "FeatureNodeChild" do

    before do
      @xml = <<xxx
<map>
  <node TEXT='Cucumber features:'>
    <node TEXT='Feature: Manage websites'>
      <node TEXT='[file: manage_website.feature]'/>
      <node TEXT='In order to manage a website'></node>
      <node TEXT='I want to create and manage a website'></node>
      <node TEXT='Background:'>
        <node TEXT='Given I am the registered user Lime Neeson'></node>
        <node TEXT='And I am on login'></node>
        <node TEXT='When I login with valid credentials'></node>
        <node TEXT='Then I should see &quot;My sites&quot;'></node>
      </node>
      <node TEXT='Scenario: Sites List'>
        <node TEXT='When I go to my sites'></node>
        <node TEXT='Then I should see &quot;My First Site&quot;'></node>
        <node TEXT='And I should see &quot;My Second Site;'></node>
      </node>
      <node TEXT='Scenario: Creating a new site'>
        <node TEXT='When I go to my sites'></node>
        <node TEXT='Then I should see &quot;New site&quot;'></node>
      </node>
    </node>
  </node>
</map>
xxx

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
    <node TEXT='Feature: Test feature'/>
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
      feat.filename.should match 'my_filename.feature'
    end

    it "creates a file name if none was specified based on the feature title" do
      doc = REXML::Document.new @xml
      node = REXML::XPath.first doc, '//node[attribute::TEXT="Feature: Test feature"]'
      feat = FeatureNode.new(node)
      feat.filename.should match 'test_feature.feature'
    end

    it "has a method to return a file name from text in the mind map specifying the file name" do
      @feature_node.filename_from('').should match ''
      @feature_node.filename_from('[file: filename.feature]').should match 'filename.feature'
      @feature_node.filename_from('[file: "filename.feature"]').should match 'filename.feature'
      @feature_node.filename_from('[file:filename.feature]').should match 'filename.feature'
      @feature_node.filename_from('[file:"filename.feature"]').should match 'filename.feature'
      @feature_node.filename_from('[ File:  "  filename.feature  " ] ').should match 'filename.feature'
    end


    it "returns itself in Cucumber feature file format as a single string of text"

  end

end

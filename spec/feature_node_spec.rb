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

    it "populates itself from a FreeMind XML document node that is a child of a feature node"

    it "returns a text representation of itself padded for output to a Cucumber feature file"

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

    end

    it "populates itself from a XML document node describing a Cucumber feature" do
      doc = REXML::Document.new @xml
      node = REXML::XPath.first doc, '//node[attribute::TEXT="Cucumber features:"]'
      feat = FeatureNode.new(node)
      feat.should_not be_nil
    end

    it "returns the file name for the feature as specified in the document" do
      doc = REXML::Document.new @xml_with_filename
      node = REXML::XPath.first doc, '//node[attribute::TEXT="Cucumber features:"]'
      feat = FeatureNode.new(node)
      feat.filename.should match 'my_filename.feature'
    end

    it "creates a file name if none was specified based on the feature title" do
      doc = REXML::Document.new @xml
      node = REXML::XPath.first doc, '//node[attribute::TEXT="Cucumber features:"]'
      feat = FeatureNode.new(node)
      feat.filename.should match 'test_feature.feature'
    end

    it "returns itself in Cucumber feature file format as a single string of text"

  end

end

require File.dirname(__FILE__) + '/spec_helper'
require 'cukehead/feature_file_section'

describe "FeatureFileSection" do
  
  it "should take a FreemindBuilder and a title as parameters when creating a new instance" do
    builder = FreemindBuilder.new
    title = "Feature: A test"
    section = FeatureFileSection.new builder, title
    section.should_not be_nil    
  end
  
  it "should accept a line of text" do
    section = FeatureFileSection.new FreemindBuilder.new, "Feature: A test"
    section.add "A line"
    section.lines.should have(1).line
  end
    
  
end
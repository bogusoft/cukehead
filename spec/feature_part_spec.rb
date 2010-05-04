require File.dirname(__FILE__) + '/spec_helper'
require 'cukehead/feature_part'

describe "FeaturePart" do
  before do
    @part = FeaturePart.new
  end
    
  it "should have a 'title' attribute" do
    s = "Feature: Test feature"
    @part.title = s
    @part.title.should == s
  end
  
  it "should let you add lines and have a 'lines' attribute reader" do
    a = ["In order describe a feature", "As a feature object", "I want to have lines of text"]
    a.each {|line| @part.add_line(line)}
    @part.lines.should == a
  end
  
  it "should have a 'tags' attribute" do
    a = ["@test"]
    @part.tags = a
    @part.tags.should == a
  end
  
  it "should take the title as a parameter when creating a new instance" do
    s = "A feature part"
    part = FeaturePart.new s
    part.title.should == s
  end
  
end

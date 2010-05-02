require File.dirname(__FILE__) + '/spec_helper'
require 'cukehead/feature_section'

describe "FeatureSection" do
  before do
    @section = FeatureSection.new
  end
    
  it "should have a 'title' attribute" do
    s = "Feature: Test feature"
    @section.title = s
    @section.title.should == s
  end
  
  it "should let you add lines and have a 'lines' attribute reader" do
    a = ["In order describe a feature", "As a feature object", "I want to have lines of text"]
    a.each {|line| @section.add_line(line)}
    @section.lines.should == a
  end
  
  it "should have a 'tags' attribute" do
    a = ["@test"]
    @section.tags = a
    @section.tags.should == a
  end
  
#  it "should have a 'filename' attribute" do
#    s = "test.feature"
#    @section.filename = s
#    @section.filename.should == s
#  end
  
end

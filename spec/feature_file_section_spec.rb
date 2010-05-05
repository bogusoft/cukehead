require File.dirname(__FILE__) + '/spec_helper'
require 'cukehead/feature_file_section'

module Cukehead
  
  describe "FeatureFileSection" do

    it "should take a FreemindBuilder and a title as parameters when creating a new instance" do
      builder = FreemindBuilder.new
      title = "Feature: A test"
      section = FeatureFileSection.new builder, title
      section.should_not be_nil
    end

  #  it "should accept a line of text" do
  #    section = FeatureFileSection.new FakeFreemindBuilder.new, "Feature: A test"
  #    section.add "A line"
  #    section.finish
  #    section.lines.should have(1).line
  #  end

    it "should have 'add', 'set_tags', and 'finish' methods" do
      section = FeatureFileSection.new FakeFreemindBuilder.new, "Feature: A test"
      section.should respond_to "add", "set_tags", "finish"
    end

    it "is a base class and should raise an exception if the 'finish' method is called" do
      section = FeatureFileSection.new FakeFreemindBuilder.new, "Feature: A test"
      lambda{ section.finish }.should raise_exception
    end

  end

  describe "FeatureSection" do

    it "should take a FreemindBuilder, a title, and a filename as parameters when creating a new instance" do
      builder = FreemindBuilder.new
      title = "Feature: A test"
      filename = "test.feature"
      section = FeatureSection.new builder, title, filename
      section.should_not be_nil
    end

    it "should be a FeatureFileSection" do
      section = FeatureSection.new FakeFreemindBuilder.new, "Feature: A test", "test.feature"
      section.should be_a FeatureFileSection
    end

    it "implements the 'finish' method" do
      fakebuilder = FakeFreemindBuilder.new
      section = FeatureSection.new fakebuilder, "Feature: A test", "test.feature"
      section.add "A line"
      section.finish
      fakebuilder.lines.should have(1).line
    end

  end

  describe "BackgroundSection" do

    it "should be a FeatureFileSection" do
      section = BackgroundSection.new FakeFreemindBuilder.new, "Feature: A test"
      section.should be_a FeatureFileSection
    end

    it "implements the 'finish' method" do
      fakebuilder = FakeFreemindBuilder.new
      section = BackgroundSection.new fakebuilder, "Feature: A test"
      section.add "A line"
      section.finish
      fakebuilder.lines.should have(1).line
    end

  end

  describe "ScenarioSection" do

    it "should be a FeatureFileSection" do
      section = ScenarioSection.new FakeFreemindBuilder.new, "Feature: A test"
      section.should be_a FeatureFileSection
    end

    it "implements the 'finish' method" do
      fakebuilder = FakeFreemindBuilder.new
      section = ScenarioSection.new fakebuilder, "Feature: A test"
      section.add "A line"
      section.finish
      fakebuilder.lines.should have(1).line
    end

  end

end

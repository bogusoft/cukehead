require File.dirname(__FILE__) + '/spec_helper'
require 'cukehead/feature_section'
require 'cukehead/freemind_builder'

describe "FreemindBuilder" do
  it "should add a feature and specify the name of the file it is from" do
    feature = FeatureSection.new
    feature.title = "Feature: Test feature"
    filename = "test.feature"
    builder = FreemindBuilder.new
    builder.add_feature feature, filename
    builder.xml.should match /.*Test feature.*/ 
  end
end

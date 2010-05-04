require File.dirname(__FILE__) + '/spec_helper'
require 'cukehead/feature_reader'

describe "FeatureReader" do
  
  before do
    @filetext1 = <<EOF
Feature: A test    
    
EOF

  end

  it "extracts feature sections from the text of a Cucumber feature file" do
    reader = FeatureReader.new
    reader.extract_features @filetext1  
    xml = reader.freemind_xml
    xml.should match /.*Cucumber features:.*Feature: A test.*/
  end
    
end




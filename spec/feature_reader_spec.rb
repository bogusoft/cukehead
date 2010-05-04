require File.dirname(__FILE__) + '/spec_helper'
require 'cukehead/feature_reader'

describe "FeatureReader" do
  
  before do
    #@filename1 = File.expand_path(File.join(File.dirname(__FILE__), "..", "tmp/test-1.feature"))
    @filename1 = File.join($testing_tmp, "test-1.feature")
    @filetext1 = <<EOF
Feature: A test    
    
EOF
    $stderr.puts "DEBUG: @filename1='#{@filename1}'" 
    FileUtils.mkdir($testing_tmp) unless File.directory? $testing_tmp
    File.open(@filename1, 'w') do |f|
      f.write(@filetext1)
    end
  end

  it "extracts feature sections from the text of a Cucumber feature file" do
    reader = FeatureReader.new
    reader.extract_features @filename1, @filetext1  
    xml = reader.freemind_xml
    xml.should match /.*Cucumber features:.*Feature: A test.*/
  end
  
  
    
end




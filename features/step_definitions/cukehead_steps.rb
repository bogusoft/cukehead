$:.push File.join(File.dirname(__FILE__), '..', '..', 'lib')
require 'cukehead/feature_reader'

#require 'rubygems'; require 'ruby-debug'; debugger


Given /^a feature file containing the text:$/ do |string|
   @text = string
end


When /^I read the feature into a mind map$/ do
  @reader = Cukehead::FeatureReader.new
  @reader.extract_features 'testdata.feature', @text
end


Then /^the mind map XML should contain a node with the TEXT attribute "([^\"]*)"$/ do |arg1|
  xml = @reader.freemind_xml
  xml.should match /#{arg1}/
end


Then /^reading that feature should raise an exception matching "([^\"]*)"$/ do |arg1|
  @reader = Cukehead::FeatureReader.new
  lambda {@reader.extract_features 'testdata.feature', @text
    }.should raise_exception {|exception| exception.message.should match(/#{arg1}/i)}
end


$:.push File.join(File.dirname(__FILE__), '..', '..', 'lib')
require 'cukehead/feature_reader'


Given /^a feature file containing the text:$/ do |string|
   @text = string
end

#require 'rubygems'; require 'ruby-debug'; debugger

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


#When /^the FeatureReader parses the text from the file$/ do
#  @reader = FeatureReader.new(text)
#end

#Then /^there should be a feature section titled "Do something'$/ do
#  features = @reader.getFeatures
#  found = false
#  features.each {|feature| found = true if feature.title == "Do something"}
#  found.should_be true
#end

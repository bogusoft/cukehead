Given /^a feature file with:$/ do |text|
  @text = text
end

When /^the FeatureReader parses the text from the file$/ do
  @reader = FeatureReader.new(text)
end

Then /^there should be a feature section titled "Do something'$/ do
  features = @reader.getFeatures
  found = false
  features.each {|feature| found = true if feature.title == "Do something"}
  found.should_be true
end

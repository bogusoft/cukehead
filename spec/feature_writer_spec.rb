require File.dirname(__FILE__) + '/spec_helper'

describe "FeatureWriter" do

  before do
    # Create a hash of filename => featuretext.
    @features = {
      "test1.feature" => "Feature: Test 1",
      "test2.feature" => "Feature: Test 2"
    }
  end

  it "writes to a subdirectory named 'features' in the current directory by default"


  it "has an output directory attribute that can be set"


  it "takes a hash of filename => featuretext and writes feature files"


  it "does not overwrite existing files by default"


  it "has an overwrite attribute that can be set"


  it "overwrites existing files if the overwrite attrubute is set to true"


end

require File.dirname(__FILE__) + '/spec_helper'
require 'cukehead/app'

describe "Cukehead application" do

  it "reads a set of Cucumber features and create a FreeMind mind map"

  it "looks for feature files in a 'features' sub-directory of the current directory by default" do
    app = Cukehead::App.new
    app.features_path.should match Dir.getwd + '/features'
  end

  it "accepts a features path to specify where to look for feature files" do
    app = Cukehead::App.new
    dir = File.join $testing_tmp, 'features'
    app.features_path = dir
    app.features_path.should match dir
  end

  it "creates 'cukehead.mm' in a 'mm' sub-directory of the current directory by default"

  it "accepts a mind map file name to override the default"

  it "creates the output directory if it does not exist"

  it "does not overwrite an existing mind map file"

  it "accepts an overwrite option that allows it to replace an exiting mind map file"

  it "accepts an optional file name of an existing mind map"

  it "adds feature nodes under an existing 'Cucumber features:' node"

end
require File.dirname(__FILE__) + '/spec_helper'
require 'cukehead/app'

describe "Cukehead application" do
  before do
    @app = Cukehead::App.new
  end

  it "reads a set of Cucumber features and create a FreeMind mind map" do
    source = File.dirname(__FILE__) + '/../testdata/project1/features'
    target = File.join $testing_tmp, 'app_spec_test.mm'
    File.directory?(source).should be_true
    @app.features_path = source
    File.delete target if File.exists? target
    File.exists?(target).should be_false
    @app.mindmap_filename = target
    @app.read_features 
    @app.write_mindmap
    File.exists?(target).should be_true
  end

  it "looks for feature files in a 'features' sub-directory of the current directory by default" do
    @app.features_path.should match Dir.getwd + '/features'
  end

  it "accepts a features path to specify where to look for feature files" do
    dir = File.join $testing_tmp, 'features'
    @app.features_path = dir
    @app.features_path.should match dir
  end

  it "creates 'cukehead.mm' in a 'mm' sub-directory of the current directory by default" do
    @app.mindmap_filename.should match Dir.getwd + '/mm/cukehead.mm'
  end

  it "accepts a mind map file name to override the default" do
    fn = File.join $testing_tmp, 'app_spec_test.mm'
    @app.mindmap_filename = fn
    @app.mindmap_filename.should match fn
  end

  it "creates the output directory if it does not exist" do
    fn = File.join $testing_tmp, 'app_spec_test/test.mm'
    @app.mindmap_filename = fn
    
  end


  it "does not overwrite an existing mind map file"

  it "accepts an overwrite option that allows it to replace an exiting mind map file"

  it "accepts an optional file name of an existing mind map"

  it "adds feature nodes under an existing 'Cucumber features:' node"

end
require File.dirname(__FILE__) + '/spec_helper'
require 'cukehead/app'

describe "Cukehead application" do

  before do
    @testdata_dir = File.dirname(__FILE__) + '/../testdata'
    @features_dir = @testdata_dir + '/project1/features'
    File.directory?(@features_dir).should be_true
    File.directory?($testing_tmp).should be_true
    @app = Cukehead::App.new
  end

  it "reads a set of Cucumber features and create a FreeMind mind map" do
    @app.features_path = @features_dir
    target = File.join $testing_tmp, 'app_spec_test.mm'
    File.delete target if File.exists? target
    File.exists?(target).should be_false
    @app.mindmap_filename = target
    @app.read_features 
    result = @app.write_mindmap
    result.should be_true
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

  it "creates 'cukehead-output.mm' in a 'mm' sub-directory of the current directory by default" do
    @app.mindmap_filename.should match Dir.getwd + '/mm/cukehead-output.mm'
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

  it "does not overwrite an existing mind map file" do
    @app.features_path = @features_dir
    target = File.join $testing_tmp, 'app_spec_test.mm'
    @app.mindmap_filename = target
    File.open(target, 'w') {|f| f.write("###")}
    File.exists?(target).should be_true
    @app.read_features
    @app.write_mindmap
    File.open(target, 'r') {|f|
      s = f.readline
      s.should match "###"
    }
  end

  it "accepts an overwrite option that allows it to replace an exiting mind map file" do
    @app.features_path = @features_dir
    target = File.join $testing_tmp, 'app_spec_test.mm'
    @app.mindmap_filename = target
    File.open(target, 'w') {|f| f.write("###")}
    File.exists?(target).should be_true
    @app.read_features
    @app.do_overwrite = true
    @app.write_mindmap
    File.open(target, 'r') {|f|
      s = f.readline
      s.should_not match "###"
    }
  end

  it "accepts an optional file name of an existing mind map" do
    @app.source_mindmap_filename = 'test.mm'
  end

  it "adds feature nodes under an existing 'Cucumber features:' node" do
    @app.features_path = @features_dir
    target = File.join $testing_tmp, 'app_spec_insert_test.mm'
    @app.mindmap_filename = target
    source_mm = File.join(@testdata_dir, 'insert_test.mm')
    @app.source_mindmap_filename = source_mm
    @app.read_features
    @app.do_overwrite = true
    @app.write_mindmap
    mm = ''
    File.open(target, 'r') {|f|
      mm = f.readlines
    }
    # *!* Wow. This spec is ugly. There must be a better way.
    doc = REXML::Document.new(mm.join)
    doc.should_not be_nil
    node = REXML::XPath.first(doc, '//node[attribute::TEXT="Here"]')
    node.should_not be_nil
    child = node.elements.first
    child.to_s.should match /.*Cucumber features:.*/
    grandchild = child.elements[2]
    grandchild.to_s.should match /.*Test feature.*/
  end

end

describe "Cukehead application (generating features from mind map)" do

  it "reads a FreeMind mind map and creates a set of Cucumber feature files"

  it "looks for a single file matching *.mm in a 'mm' subdirectory of the current directory by default"

  it "accepts the name of the mind map file to read overriding the default"

  it "creates features in a 'features' sub-directory of the current directory by default"

  it "accepts a features path to specify where to write feature files"

  it "accepts a mind map file name to override the default"

  it "creates the output directory if it does not exist"

  it "does not write any files if any one of the files to be writtin exists"

  it "accepts an overwrite option that allows it to replace exiting files"

end
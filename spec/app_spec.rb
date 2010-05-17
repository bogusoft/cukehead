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
    @app.features_path.should eql Dir.getwd + '/features'
  end

  it "accepts a features path to specify where to look for feature files" do
    dir = File.join $testing_tmp, 'features'
    @app.features_path = dir
    @app.features_path.should eql dir
  end

  it "creates 'cukehead-output.mm' in a 'mm' sub-directory of the current directory by default" do
    @app.mindmap_filename.should eql Dir.getwd + '/mm/cukehead-output.mm'
  end

  it "accepts a mind map file name to override the default" do
    fn = File.join $testing_tmp, 'app_spec_test.mm'
    @app.mindmap_filename = fn
    @app.mindmap_filename.should eql fn
  end

  it "creates the output directory if it does not exist" do
    outdir = File.join $testing_tmp, 'app_test_dir_create'
    FileUtils.remove_dir(outdir) if File.directory? outdir
    File.directory?(outdir).should be_false
    fn = File.join outdir, 'test.mm'
    @app.features_path = @features_dir
    @app.mindmap_filename = fn
    @app.read_features
    @app.write_mindmap
    File.directory?(outdir).should be_true
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
      s.should eql "###"
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
      s.should_not eql "###"
    }
  end

  it "accepts an optional file name of an existing mind map" do
    @app.mindmap_template_filename = 'test.mm'
  end

  it "adds feature nodes under an existing 'Cucumber features:' node" do
    @app.features_path = @features_dir
    target = File.join $testing_tmp, 'app_spec_insert_test.mm'
    @app.mindmap_filename = target
    source_mm = File.join(@testdata_dir, 'insert_test.mm')
    @app.mindmap_template_filename = source_mm
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

  before do
    # Define temporary input directory and create test mind map files.
    @in_dir =  File.join $testing_tmp, 'app_cuke_test_input'
    FileUtils.mkdir(@in_dir) unless File.directory? @in_dir
    @in_filename_1 = File.join $testing_tmp, 'test1.mm'
    File.open(@in_filename_1, 'w') {|f| f.write($testing_freemind_data)}
    File.exists?(@in_filename_1).should be_true
    @in_filename_2 = File.join $testing_tmp, 'test2.mm'
    File.open(@in_filename_2, 'w') {|f| f.write($testing_freemind_data_2)}
    File.exists?(@in_filename_2).should be_true

    # Define temporary output directory and make sure it does not exist.
    @out_dir = File.join $testing_tmp, 'app_cuke_test_output'
    FileUtils.remove_dir(@out_dir) if File.directory? @out_dir
    File.directory?(@out_dir).should be_false

    # Create an app instance to test.
    @app = Cukehead::App.new
  end


  it "reads a FreeMind mind map and creates a set of Cucumber feature files"


  it "looks for a single file matching *.mm in a 'mm' subdirectory of the current directory by default" do
    @app.default_mm_search_path.should eql Dir.getwd + '/mm/*.mm'    
  end


  it "accepts the name of the mind map file to read overriding the default" do
    # Uses mindmap_filename attribute as source for optional mind map template
    # file in 'map' mode and as destination in 'cuke' mode.
    fn = File.join $testing_tmp, 'app_spec_test.mm'
    @app.mindmap_filename = fn
    @app.mindmap_filename.should eql fn
  end


  it "creates features in a 'features' sub-directory of the current directory by default" do
    @app.features_path.should eql Dir.getwd + '/features'
  end


  it "accepts a features path to specify where to write feature files" do
    # Uses features_path attribute as source directory in 'map' mode and as
    # destination in 'cuke' mode.
    dir = File.join $testing_tmp, 'output', 'features'
    @app.features_path = dir
    @app.features_path.should eql dir
  end


  it "creates the output directory if it does not exist" do
    @app.mindmap_filename = @in_filename_1
    @app.features_path = @out_dir
    @app.read_mindmap
    @app.write_features

    File.directory?(@out_dir).should be_true
  end


  it "writes a file for each feature in the mind map"


  it "does not write any files if any one of the files to be writtin exists" do
    outdir = File.join $testing_tmp, 'app_cuke_no_overwrite'
    FileUtils.remove_dir(outdir) if File.directory? outdir
    File.directory?(outdir).should be_false

    mmfilename = File.join $testing_tmp, 'app_cuke_no_overwrite_test.mm'
    File.open(mmfilename, 'w') {|f| f.write($testing_freemind_data)}
    File.exists?(mmfilename).should be_true


    false.should be_true  #*!* not finsihed. Need test MM with multiple features.

  end


  it "accepts an overwrite option that allows it to replace exiting files"

end
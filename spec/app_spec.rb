require File.dirname(__FILE__) + '/spec_helper'
require 'cukehead/app'

describe "Cukehead application" do

  before do
    @testdata_dir = File.dirname(__FILE__) + '/../testdata'
    @features_dir = @testdata_dir + '/project1/features'
    File.directory?(@features_dir).should be_true
    File.directory?($testing_tmp).should be_true
    @test_mm_filename = File.join $testing_tmp, 'app_spec_test.mm'
    File.delete @test_mm_filename if File.exists? @test_mm_filename
    File.exists?(@test_mm_filename).should be_false
    @app = Cukehead::App.new
  end


  it "reads a set of Cucumber features and create a FreeMind mind map" do
    @app.features_path = @features_dir
    target = @test_mm_filename
    @app.mindmap_filename = target
    @app.send :read_features
    result = @app.send :write_mindmap
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
    @app.mindmap_filename = @test_mm_filename
    @app.mindmap_filename.should eql @test_mm_filename
  end


  it "creates the output directory if it does not exist" do
    outdir = File.join $testing_tmp, 'app_test_dir_create'
    FileUtils.remove_dir(outdir) if File.directory? outdir
    File.directory?(outdir).should be_false
    fn = File.join outdir, 'test.mm'
    @app.features_path = @features_dir
    @app.mindmap_filename = fn
    @app.send :read_features
    @app.send :write_mindmap
    File.directory?(outdir).should be_true
  end


  it "does not overwrite an existing mind map file" do
    @app.features_path = @features_dir
    target = @test_mm_filename
    @app.mindmap_filename = target
    File.open(target, 'w') {|f| f.write("###")}
    File.exists?(target).should be_true

    @app.send :read_features
    @app.send :write_mindmap

    File.open(target, 'r') {|f|
      s = f.readline
      s.should eql "###"
    }
  end


  it "accepts an overwrite option that allows it to replace an exiting mind map file" do
    @app.features_path = @features_dir
    target = @test_mm_filename
    @app.mindmap_filename = target
    File.open(target, 'w') {|f| f.write("###")}
    File.exists?(target).should be_true

    @app.send :read_features

    @app.do_overwrite = true
    @app.send :write_mindmap
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

    @app.send :read_features
    
    @app.do_overwrite = true
    @app.send :write_mindmap
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


  it "reads files in the features directory in order by name" do
    fdir = File.join $testing_tmp, 'features'
    FileUtils.remove_dir(fdir) if File.directory? fdir
    File.directory?(fdir).should be_false
    FileUtils.mkdir(fdir)
    # This may not be a good test because it is possible Dir[] will return the
    # files in sorted order even though they are written out of order here.
    File.open(File.join(fdir, 'carrots.feature'), 'w') {|f|f.write("Feature: Carrots\n")}
    File.open(File.join(fdir, 'apples.feature'), 'w') {|f|f.write("Feature: Apples\n")}
    File.open(File.join(fdir, 'bananas.feature'), 'w') {|f|f.write("Feature: Bananas\n")}
    @app.features_path = fdir
    @app.send :read_features
    xml = @app.feature_reader.freemind_xml
    xml.should match /.*Apples.*Bananas.*Carrots.*/m
  end

end


describe "Cukehead application (generating features from mind map)" do

  before do
    # Define temporary mind map file and make sure the file does not exist.
    @test_mm_filename = File.join $testing_tmp, 'app_spec_test.mm'
    File.delete @test_mm_filename if File.exists? @test_mm_filename
    File.exists?(@test_mm_filename).should be_false

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


  it "looks for a single file matching *.mm in a 'mm' subdirectory of the current directory by default" do
    result = @app.send :default_mm_search_path
    result.should eql Dir.getwd + '/mm/*.mm'
  end


  it "accepts the name of the mind map file to read overriding the default" do
    # Uses mindmap_filename attribute as source for optional mind map template
    # file in 'map' mode and as destination in 'cuke' mode.
    @app.mindmap_filename = @test_mm_filename
    @app.mindmap_filename.should eql @test_mm_filename
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
    @app.send :read_mindmap
    @app.send :write_features

    File.directory?(@out_dir).should be_true
  end


  it "writes a file for each feature in the mind map" do
    @app.mindmap_filename = @in_filename_2
    @app.features_path = @out_dir
    @app.send :read_mindmap
    @app.send :write_features
    a = []
    Dir[File.join(@out_dir, '*')].each {|fn| a << File.basename(fn)}
    a.should have(2).files
    a.should include('first_feature.feature', 'second_feature.feature')
  end


  it "does not write any files if any one of the files to be written already exists" do
    FileUtils.mkdir(@out_dir)
    fn = File.join @out_dir, 'second_feature.feature'
    File.open(fn, 'w') {|f| f.write('###')}
    File.exists?(fn).should be_true
    @app.mindmap_filename = @in_filename_2
    @app.features_path = @out_dir
    @app.send :read_mindmap
    @app.send :write_features
    @app.errors.should have(1).error
    @app.errors.first.to_s.should match /exists/i
    a = Dir[File.join(@out_dir, '*')]
    a.should have(1).file
    File.open(fn, 'r') {|t| t.readline.should eql '###' }
  end


  it "accepts an overwrite option that allows it to replace exiting files" do
    FileUtils.mkdir(@out_dir)
    fn = File.join @out_dir, 'second_feature.feature'
    File.open(fn, 'w') {|f| f.write('###')}
    File.exists?(fn).should be_true
    @app.mindmap_filename = @in_filename_2
    @app.features_path = @out_dir
    @app.do_overwrite = true
    @app.send :read_mindmap
    @app.send :write_features
    @app.errors.should have(0).errors
    a = Dir[File.join(@out_dir, '*')]
    a.should have(2).files
    File.open(fn, 'r') {|t| t.readline.should_not eql '###' }
  end

  it "returns an error message if no features were found in the mind map" do
    File.open(@test_mm_filename, 'w') {|f| f.write($testing_freemind_data_nocukes)}
    File.exists?(@test_mm_filename).should be_true
    @app.mindmap_filename = @test_mm_filename
    @app.features_path = @out_dir
    @app.do_overwrite = true
    @app.send :read_mindmap
    @app.send :write_features
    @app.errors.should have(2).errors
    @app.errors[0].to_s.should match /No Cucumber features found/
    @app.errors[1].to_s.should match /may be missing a "Cucumber features:" node/
  end

end
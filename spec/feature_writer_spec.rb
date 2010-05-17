require File.dirname(__FILE__) + '/spec_helper'
require 'cukehead/feature_writer'

module Cukehead

  describe "FeatureWriter" do

    before do
      @features = {
        "test1.feature" => "Feature: Test 1",
        "test2.feature" => "Feature: Test 2"
      }
      @writer = FeatureWriter.new
      @outdir = File.join($testing_tmp, 'feature_writer_test', 'features')
      FileUtils.remove_dir(@outdir) if File.directory? @outdir
    end


    it "writes to a subdirectory named 'features' in the current directory by default" do
      @writer.output_path.should eql File.join(Dir.getwd, 'features')
    end


    it "has an output directory attribute that can be set" do
      @writer.output_path = @outdir
      @writer.output_path.should eql @outdir
    end


    it "takes a hash of filename => featuretext and writes feature files" do
      @writer.output_path = @outdir
      @writer.write_features(@features)
    end


    it "does not overwrite existing files by default" do
      fn = File.join(@outdir, 'test1.feature')
      FileUtils.mkdir_p @outdir
      File.open(fn, 'w') {|f| f.write('###')}
      File.exists?(fn).should be_true
      @writer.output_path = @outdir
      @writer.write_features(@features)
      @writer.errors.should have(1).items
      File.open(fn, 'r') {|f|
        s = f.readline
        s.should eql "###"
      }
    end


    it "has an overwrite attribute that can be set" do
      @writer.overwrite = true
    end


    it "overwrites existing files if the overwrite attrubute is set to true" do
      fn = File.join(@outdir, 'test1.feature')
      FileUtils.mkdir_p @outdir
      File.open(fn, 'w') {|f| f.write('###')}
      File.exists?(fn).should be_true
      @writer.output_path = @outdir
      @writer.overwrite = true
      @writer.write_features(@features)
      @writer.errors.should have(0).items
      File.open(fn, 'r') {|f|
        s = f.readline
        s.should eql "Feature: Test 1"
      }
    end

  end

end

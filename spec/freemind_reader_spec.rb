require File.dirname(__FILE__) + '/spec_helper'
require 'cukehead/freemind_reader'

module Cukehead

  describe "FreemindReader" do

    before do
      @test_filename = File.join $testing_tmp, 'freemind_reader_test_input.mm'
    end

    it "takes a file name when initializing and loads it as an XML document" do
      File.open(@test_filename, 'w') {|f| f.write($testing_freemind_data)}
      File.exists?(@test_filename).should be_true
      @reader = FreemindReader.new(@test_filename)
      @reader.should_not be_nil
    end

    it "can find a node containing Cucumber features in the XML document" do
      File.open(@test_filename, 'w') {|f| f.write($testing_freemind_data)}
      File.exists?(@test_filename).should be_true
      @reader = FreemindReader.new(@test_filename)
      @reader.cucumber_features_node.should_not be_nil
    end

    it "extracts features as text from the XML document as a hash {filename => text}" do
      File.open(@test_filename, 'w') {|f| f.write($testing_freemind_data)}
      File.exists?(@test_filename).should be_true
      @reader = FreemindReader.new(@test_filename)
      result = @reader.get_features
      result.should be_a Hash
      result.should have(1).feature
      filename, text = result.shift
      filename.should eql 'manage_website.feature'
      text.should match /^Feature: Manage websites.*/m
    end
    
    it "returns an empty hash if there are no Cucumber features nodes in the XML document" do
      File.open(@test_filename, 'w') {|f| f.write($testing_freemind_data_nocukes)}
      File.exists?(@test_filename).should be_true
      @reader = FreemindReader.new(@test_filename)
      result = @reader.get_features
      result.should be_a Hash
      result.should have(0).items
    end

    it "ignores case when finding a cucumber features node in the mind map." do
      File.open(@test_filename, 'w') {|f| f.write($testing_freemind_data_case2)}
      File.exists?(@test_filename).should be_true
      @reader = FreemindReader.new(@test_filename)
      @reader.cucumber_features_node.should_not be_nil
    end
    
  end

end
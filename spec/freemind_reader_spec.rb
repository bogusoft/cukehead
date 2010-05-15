require File.dirname(__FILE__) + '/spec_helper'
require 'cukehead/freemind_reader'

module Cukehead

  describe "FreemindReader" do

    before do
      test_filename = File.join $testing_tmp, 'freemind_reader_test_input.mm'
      test_data = <<xxx
<map>
  <node TEXT='Cucumber features:'>
    <node TEXT='Feature: Manage websites'>
      <node TEXT='[file: manage_website.feature]'/>
      <node TEXT='In order to manage a website'></node>
      <node TEXT='I want to create and manage a website'></node>
      <node TEXT='Background:'>
        <node TEXT='Given I am the registered user Lime Neeson'></node>
        <node TEXT='And I am on login'></node>
        <node TEXT='When I login with valid credentials'></node>
        <node TEXT='Then I should see &quot;My sites&quot;'></node>
      </node>
      <node TEXT='Scenario: Sites List'>
        <node TEXT='When I go to my sites'></node>
        <node TEXT='Then I should see &quot;My First Site&quot;'></node>
        <node TEXT='And I should see &quot;My Second Site;'></node>
      </node>
      <node TEXT='Scenario: Creating a new site'>
        <node TEXT='When I go to my sites'></node>
        <node TEXT='Then I should see &quot;New site&quot;'></node>
      </node>
    </node>
  </node>
</map>
xxx
      File.open(test_filename, 'w') {|f| f.write(test_data)}
      File.exists?(test_filename).should be_true
      @reader = FreemindReader.new(test_filename)
    end

    it "takes a file name when initializing and loads it as an XML document" do
      @reader.should_not be_nil
    end

    it "can find a node containing Cucumber features in the XML document" do
      @reader.cucumber_features_node.should_not be_nil
    end

    it "extracts features as text from the XML document as a hash {filename => text}" do
      result = @reader.get_features
      result.should be_a Hash
      result.should have(1).feature
      filename, text = result.shift
      filename.should match 'manage_website.feature'
      text.should match /^Feature: Manage websites.*/m
    end
    
  end

end
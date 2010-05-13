require File.dirname(__FILE__) + '/spec_helper'

describe "cukehead" do
  it "should run" do
    result = system("#{$cukehead_bin}")
    result.should be_true
  end

  it "should display a help message if no command line arguments are given" do
    #puts "DEBUG: #{$cukehead_bin}"
    result = `#{$cukehead_bin}`
    #puts "DEBUG: result='#{result}'"
    result.should match /.*Usage:.*/
  end

  it "should display a help message if '--help' command line argument is given" do
    result = `#{$cukehead_bin} --help`
    result.should match /.*Usage:.*/
  end

  it "should read features and create a mind map if 'map' command line argument is given" do
    result = `#{$cukehead_bin} map -o`
    puts "DEBUG: result='#{result}'"
    puts "DEBUG: result.class='#{result.class}'"
    result.should match /^Reading.*Writing.*/m
  end
  

end
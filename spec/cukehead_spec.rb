require File.dirname(__FILE__) + '/spec_helper'

describe "cukehead" do
  it "should run" do
    result = system("#{$cukehead_bin}")
    result.should be_true
  end

  it "should display a usage message if no command line arguments are given" do
    puts "DEBUG: #{$cukehead_bin}"
    result = `#{$cukehead_bin}`
    puts "DEBUG: result='#{result}'"
    false.should be_true #not!
  end
end
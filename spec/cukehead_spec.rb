require File.dirname(__FILE__) + '/spec_helper'

def run_cukehead(params = '')
  cmdline = params.empty? ? $cukehead_bin : $cukehead_bin + ' ' + params
  #puts "DEBUG: run$ #{cmdline}"
  result = `#{cmdline}`
  #puts "DEBUG: result='#{result}'"
  result
end

describe "cukehead" do

  before do
    @testdata_dir = File.dirname(__FILE__) + '/../testdata'
    @features_dir = @testdata_dir + '/project1/features'
    File.directory?(@features_dir).should be_true
    File.directory?($testing_tmp).should be_true
  end

  it "should run" do
    result = system("#{$cukehead_bin}")
    result.should be_true
  end

  it "should display a help message if no command line arguments are given" do
    result = run_cukehead
    result.should match /.*Usage:.*/
  end

  it "should display a help message if '--help' command line argument is given" do
    result = run_cukehead '--help'
    result.should match /.*Usage:.*/
  end

  it "should read features and create a mind map if 'map' command line argument is given" do
    result = run_cukehead 'map -o'
    result.should match /^Reading.*Writing.*/m
  end

  it "shows an error message and does not overwrite an existing mind map file" do
    output_filename = File.join $testing_tmp, 'cukehead_spec_test.mm'
    File.open(output_filename, 'w') {|f| f.write("###")}
    File.exists?(output_filename).should be_true

    params = 'map -p ' + @features_dir + ' -m ' + output_filename
    result = run_cukehead params
    result.should match /.*already exists.*/

    File.open(output_filename, 'r') {|f|
      s = f.readline
      s.should match "###"
    }
  end
  

end
require File.dirname(__FILE__) + '/spec_helper'

def run_cukehead(params = '')
  cmdline = params.empty? ? $cukehead_bin : $cukehead_bin + ' ' + params
  puts "DEBUG: run$ #{cmdline}"
  result = `#{cmdline}`
  puts "DEBUG: result='#{result}'"
  result
end


describe "cukehead" do

  before do
    @testdata_dir = File.dirname(__FILE__) + '/../testdata'
    @features_dir = @testdata_dir + '/project1/features'
    @source_mm = @testdata_dir + '/project2/mm/testdata.mm'
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


  it "should include available commands and options in the help message" do
    result = run_cukehead
    result.should match /\bmap\b/
    result.should match /\bcuke\b/
    result.should match /.*--help\b/
    result.should include ' -h '
    result.should match /.*--overwrite\b/
    result.should include ' -o '
    result.should include ' --mm-filename '
    result.should include ' -m '
    result.should include ' --features-path '
    result.should include ' -f '
    result.should include ' --source-mm '
    result.should include ' -s '
  end


  it "should display a help message if '--help' command line argument is given" do
    result = run_cukehead '--help'
    result.should match /.*Usage:.*/
  end


  it "should read features and create a mind map if 'map' command line argument is given" do
    params =  'map -o'
    params << ' --features-path ' + @features_dir
    params << ' --mm-filename ' + File.join($testing_tmp, 'test-output.mm')
    result = run_cukehead params
    result.should match /^Reading.*Writing.*/m
  end


  it "shows an error message and does not overwrite an existing mind map file" do
    output_filename = File.join $testing_tmp, 'cukehead_spec_test.mm'
    File.open(output_filename, 'w') {|f| f.write("###")}
    File.exists?(output_filename).should be_true

    params = 'map -f ' + @features_dir + ' -m ' + output_filename
    result = run_cukehead params
    result.should match /.*already exists.*/

    File.open(output_filename, 'r') {|f|
      s = f.readline
      s.should eql "###"
    }
  end


  it "complains about unknown command line options." do
    result = run_cukehead '--unknown-option'
    result.should match /.*error.*unrecognized.*/im
  end


  it "complains about unknown command line arguments." do
    result = run_cukehead 'UnknownArgument'
    result.should match /.*error.*unknown.*/im
  end


  it "should read a mind map and write features if 'cuke' command is given" do
    params =  'cuke -o'
    params << ' --mm-filename ' + @source_mm
    params << ' --features-path ' + File.join($testing_tmp, 'features')
    result = run_cukehead params
    result.should match /^Reading.*Writing.*/m
  end


end

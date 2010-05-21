#!/usr/bin/env ruby


class CukeheadRoundtripRunner

  def initialize
    @tmp = File.expand_path(File.join(File.dirname(__FILE__), '..', 'tmp'))
    @bin = File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin'))
  end


  def usage
    puts <<xxx

Usage: roundtrip.rb features_path
Where:
  features_path = Path to the features directory of a project to use for
                  a roundtrip comparison.

xxx
  end


  def roundtrip_test features_dir
    project_name = File.basename File.dirname(features_dir)
    output_dir = File.join @tmp, 'roundtrip', project_name
    mm_filename = File.join output_dir, 'mm', project_name + '.mm'
    features_output_dir = File.join output_dir, 'features'
    cukehead = File.join @bin, 'cukehead'
    
    # Create a mind map from the project features.
    cmd = "#{cukehead} map -o -f #{features_dir} -m #{mm_filename}"
    system(cmd)

    # Create a set of features from the resulting mind map.
    cmd = "#{cukehead} cuke -o -f #{features_output_dir} -m #{mm_filename}"
    system(cmd)

#    # Use Beyone Compare to view the results.
#    cmd = "bcompare #{features_dir} #{features_output_dir}"
#    system(cmd)

    # Use diff to view the results.
    diff_filename = File.join output_dir, 'diff.txt'
    puts "Senfing diff output to #{diff_filename}"
    cmd = "diff -a -b -u #{features_dir} #{features_output_dir} > #{diff_filename}"
    system(cmd)
  end


  def run
    if ARGV.length != 1
      usage
      exit(1)
    end
    features_path = File.expand_path ARGV[0]
    if File.directory? features_path
      if Dir[File.join(features_path, '*.feature')].empty?
        puts "ERROR: No files matching *.feature in directory " + features_path
        exit(1)
      else
        roundtrip_test features_path
      end
    else
      puts "ERROR: Directory not found " + features_path
      exit(1)
    end
  end

end


app = CukeheadRoundtripRunner.new
app.run

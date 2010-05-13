#!/usr/bin/env ruby
#

def usage
  puts <<xxx
Usage: map_project path_to_project
Where:
  path_to_project = The path to a directory containing a project that
                    includes Cucumber features you wish to map.

xxx
end

def main
  if ARGV.length == 1
    project_dir = ARGV[0]
    unless File.directory? project_dir
      puts "ERROR: Directory not found " + project_dir
      exit(1)
    end
    features_dir = File.join(project_dir, 'features')
    unless File.directory? features_dir
      puts "ERROR: Directory not found " + features_dir
      exit(1)
    end
    tmp = File.expand_path(File.join(File.dirname(__FILE__), '..', 'tmp'))
    bin = File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin'))
    project_name = project_dir.split('/').last.tr(' ', '_')
    #puts "project_name=#{project_name}"

    mm_filename = File.join(tmp, project_name + '.mm')
    
    cmd = File.join(bin, 'cukehead')
    cmd += ' map -o --features-path ' + features_dir
    cmd += ' --mm-filename ' +  mm_filename
    puts cmd

    system(cmd)
    
    fmcmd = 'freemind ' + mm_filename
    puts fmcmd
    
    system(fmcmd)
  else
    usage
  end
  
end

main
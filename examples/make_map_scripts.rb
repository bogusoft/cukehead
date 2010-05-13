#!/usr/bin/env ruby

class CukeheadMapScripter

  def initialize
    @tmp = File.expand_path(File.join(File.dirname(__FILE__), '..', 'tmp'))
    @bin = File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin'))
    @dirs = []
  end


  def usage
    puts <<xxx
Usage: make_map_scripts projects_root
Where:
  projects_root = The path the top-level directory under which projects that
                  includes Cucumber features you wish to map are located.

xxx
  end

  def make_script(dirname)
    project_name = File.dirname(dirname).split('/').last
    script = File.join(@tmp, "map-#{project_name}.sh")
    mm_filename = File.join(@tmp, project_name + '.mm')
    cukehead_cmd = File.join(@bin, 'cukehead')
    cukehead_cmd += ' map -o --features-path ' + dirname
    cukehead_cmd += ' --mm-filename ' +  mm_filename
    freemind_cmd = 'freemind ' + mm_filename
    puts "Writing #{script}"
    File.open(script, 'w') {|f|
      f.write(cukehead_cmd + "\n")
      f.write(freemind_cmd)
    }
  end

  def process_directory(dirname)
    puts "Processing #{dirname}"
    found_features = false
    Dir.foreach(dirname) { |filename|
      if filename == 'features'
        found_features = true
        @dirs << File.join(dirname, filename)
      end
    }
    unless found_features
      Dir.foreach(dirname) { |filename|
        unless filename =~ /^\..*/
          filepath = File.join dirname, filename
          if File.directory? filepath
            process_directory(filepath)
          end
        end
      }
    end
  end


  def make_scripts
    #@dirs.each {|dirname| puts dirname}
    @dirs.each {|dirname| make_script dirname}
  end


  def run
    if ARGV.length != 1
      usage
      exit(1)
    end
    projects_root = File.expand_path ARGV[0]
    if File.directory? projects_root
      process_directory projects_root
      make_scripts
    else
      puts "ERROR: Directory not found " + projects_root
      exit(1)
    end
  end

end



def main
  app = CukeheadMapScripter.new
  app.run
end

main
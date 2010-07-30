require 'rubygems' unless ENV['NO_RUBYGEMS']
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'
require 'spec/rake/spectask'
require 'rake/testtask'
require 'rake/rdoctask'
require 'cucumber/rake/task'

GEM = 'cukehead'

spec = Gem::Specification.new do |s|
  s.name = "cukehead"
  s.version = "0.1.1"
  s.author = "Bill Melvin"
  s.email = "bill@bogusoft.com"
  s.homepage = "http://www.bogusoft.com/cukehead/"
  s.description = s.summary = "A gem that creates a FreeMind mind map from Cucumber feature files and vice versa."
  
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  #s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.extra_rdoc_files = ["README"]
  #s.summary = SUMMARY
  
  # Uncomment this to add a dependency
  # s.add_dependency "foo"
  
  s.require_path = 'lib'
  #s.autorequire = GEM

  #s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,spec}/**/*")

  s.executables = ["cukehead"]

  files = []
  File.open('Manifest.txt', 'r') {|f| f.each {|line| files << line.strip}}
  s.files = files
end

#task :default => :spec

desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  #t.spec_opts = %w(-fs --color)
  t.spec_opts = %w(-fs --color --debug)
end


Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

#desc "install the gem locally"
#task :install => [:package] do
#  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
#end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end


desc "run unit tests"
Rake::TestTask.new("unit_tests") {|t|
  t.pattern = 'test/*_test.rb'
  t.verbose = true
  t.warning = true
}


desc "Run RDoc to generate documentation"
Rake::RDocTask.new do |rd|
  rd.rdoc_dir = 'doc/rdocs'
  rd.main = 'README'
  rd.rdoc_files.include 'README', "lib/**/*\.rb"
  rd.options << '--all'
  rd.options << '--inline-source'
  #rd.options << '--line-numbers'
end


desc "Cucumber features"
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end


desc "Make feature files from CukeHead mind map"
task 'cukehead' do
  sh "bin/cukehead cuke -m mm/CukeHead.mm -o"
end


task :cuke => [:cukehead, :features]

task :default => [:unit_tests, :spec, :cuke]
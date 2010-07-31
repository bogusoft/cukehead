# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cukehead}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bill Melvin"]
  s.date = %q{2010-07-30}
  s.default_executable = %q{cukehead}
  s.description = %q{A gem that creates a FreeMind mind map from Cucumber feature files and vice versa.}
  s.email = %q{bill@bogusoft.com}
  s.executables = ["cukehead"]
  s.extra_rdoc_files = ["README"]
  s.files = ["LICENSE", "README", "Rakefile", "bin/cukehead", "lib/cukehead.rb", "lib/cukehead/app.rb", "lib/cukehead/feature_file_section.rb", "lib/cukehead/feature_node.rb", "lib/cukehead/feature_node_child.rb", "lib/cukehead/feature_node_tags.rb", "lib/cukehead/feature_part.rb", "lib/cukehead/feature_reader.rb", "lib/cukehead/feature_writer.rb", "lib/cukehead/freemind_builder.rb", "lib/cukehead/freemind_reader.rb", "lib/cukehead/freemind_writer.rb", "spec/app_spec.rb", "spec/cukehead_spec.rb", "spec/feature_file_section_spec.rb", "spec/feature_node_spec.rb", "spec/feature_part_spec.rb", "spec/feature_reader_spec.rb", "spec/feature_writer_spec.rb", "spec/freemind_builder_spec.rb", "spec/freemind_reader_spec.rb", "spec/freemind_writer_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{http://www.bogusoft.com/cukehead/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A gem that creates a FreeMind mind map from Cucumber feature files and vice versa.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

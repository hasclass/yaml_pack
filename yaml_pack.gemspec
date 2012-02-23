# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yaml_pack"

Gem::Specification.new do |s|
  s.name        = "yaml_pack"
  s.version     = YamlPack::VERSION
  s.authors     = ["sebastian"]
  s.email       = ["sebastian.burkhard@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Framework for complex yaml configuration file structures.}
  s.description = %q{
    YamlPack is a small framework for writing large and complex configuration files in yml.
    It supports nesting and merging merging yaml files.
  }

  s.rubyforge_project = "yaml_pack"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
end

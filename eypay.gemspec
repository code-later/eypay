# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "eypay/version"

Gem::Specification.new do |s|
  s.name        = "eypay"
  s.version     = Eypay::VERSION
  s.authors     = ["Björn Vollmer"]
  s.email       = ["bjoern.vollmer@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "eypay"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rails', '3.0.4'
  s.add_development_dependency 'rspec-rails', '~> 2.5'
end

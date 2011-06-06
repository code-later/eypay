# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "eypay/version"

Gem::Specification.new do |s|
  s.name        = "eypay"
  s.version     = Eypay::VERSION
  s.authors     = ["orko"]
  s.email       = ["bjoern.vollmer@gmail.com"]
  s.homepage    = "https://github.com/orko/eypay"
  s.summary     = %q{Payment Integration}
  s.description = %q{Integration of different payment strategies}

  s.rubyforge_project = "eypay"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

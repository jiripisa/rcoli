# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rcoli/version"

Gem::Specification.new do |s|
  s.name        = "rcoli"
  s.version     = RCoLi::VERSION
  s.authors     = ["Jiri Pisa", "Jaroslav Barton"]
  s.email       = ["jirka.pisa@gmail.com", "jaroslav@bartonovi.eu"]
  s.homepage    = "https://github.com/jiripisa/rcoli"
  s.summary     = "The complete solution for commandline application written in ruby."
  s.description = "The complete solution for commandline application written in ruby."
  s.licenses    = ["MIT"]

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency("highline", "~> 1.6.11")
  s.add_runtime_dependency('paint', '~> 0.8.7')
  s.add_development_dependency("rake")
end
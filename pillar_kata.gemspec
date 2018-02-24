# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pillar_kata/version'

Gem::Specification.new do |spec|
  spec.name          = "pillar_kata"
  spec.version       = PillarKata::VERSION
  spec.authors       = ["Patrick Villanueva"]
  spec.email         = ["villanuv@yahoo.com"]

  spec.summary       = "For Pillar Technology's Vending Machine Kata"
  spec.homepage      = "http://github.com/villanuv/pillar_kata"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end

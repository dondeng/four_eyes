# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'four_eyes/version'

Gem::Specification.new do |spec|
  spec.name          = "four_eyes"
  spec.version       = FourEyes::VERSION
  spec.authors       = ["Dennis Ondeng"]
  spec.email         = ["dondeng2@gmail.com"]
  spec.summary       = %q{A gem to implement the maker-checker principle. 4-eyes principle}
  spec.description   = %q{A gem to implement the maker-checker principle. 4-eyes principle}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rails', '~> 3.2.19'
end

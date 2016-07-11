$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'four_eyes/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'four_eyes'
  s.version     = FourEyes::VERSION
  s.authors     = ['Dennis Ondeng']
  s.email       = ['dondeng2@gmail.com']
  #s.homepage    = 'TODO'
  s.summary     = 'A gem to implement the maker-checker principle. The 4-eyes principle'
  s.description = 'A gem to implement the maker-checker principle. The 4-eyes principle'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails',  ['>= 3.2', '< 5.0']

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec-rails'
end

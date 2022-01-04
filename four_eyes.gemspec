$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'four_eyes/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'four_eyes'
  s.version     = FourEyes::VERSION
  s.authors     = ['Dennis Ondeng']
  s.email       = ['dondeng2@gmail.com']
  s.homepage    = 'https://github.com/dondeng/four_eyes'
  s.summary     = 'A gem to implement the maker-checker principle. The 4-eyes principle'
  s.description = 'courtesy - Wikipedia: Maker-checker (or Maker and Checker, or 4-Eyes) is one of the central principles of authorization in the information systems of financial organizations.The principle of maker and checker means that for each transaction, there must be at least two individuals necessary for its completion. While one individual may create a transaction, the other individual should be involved in confirmation/authorization of the same. Here the segregation of duties plays an important role. In this way, strict control is kept over system software and data, keeping in mind functional division of labor between all classes of employees.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 6.1'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
end

#require "bundler/gem_tasks"

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.name = "four_eyes"
  gem.summary = "A gem to implement the maker-checker principle. The 4-eyes principle"
  gem.email = "dondeng2@gmail.com"
  gem.homepage = "https://github.com/dondeng/four_eyes"
  gem.description = "A gem to implement the maker-checker principle. The 4-eyes principle"
  gem.authors = ["Dennis Ondeng"]
  gem.files = FileList["[A-Z]*", "{bin,generators,lib,test}/**/*"]


end

Jeweler::RubygemsDotOrgTasks.new


require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "four_eyes #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

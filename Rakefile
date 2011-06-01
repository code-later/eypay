# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Eypay::Application.load_tasks


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "eypay"
    gem.summary = "Payment Integration"
    gem.description = "Integration of different payment strategies"
    gem.email = "bjoern.vollmer@googlemail.com"
    gem.homepage = "https://github.com/orko/eypay"
    gem.authors = ["orko"]
    gem.version = "0.0.1"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

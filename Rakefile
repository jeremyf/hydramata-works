begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks

begin
  APP_RAKEFILE = File.expand_path('../spec/internal/Rakefile', __FILE__)
  load 'rails/tasks/engine.rake'
rescue LoadError
  puts "Unable to load all app tasks for #{APP_RAKEFILE}"
end

require 'engine_cart/rake_task'
require 'rspec/core/rake_task'

namespace :spec do
  RSpec::Core::RakeTask.new(:all) do
    ENV['COVERAGE'] = 'true'
  end

  desc 'Run the Travis CI specs'
  task :travis do
    ENV['RAILS_ENV'] = 'test'
    spec_helper = File.expand_path('../spec/spec_helper.rb', __FILE__)
    ENV['SPEC_OPTS'] = "--profile 20 --require #{spec_helper}"
    Rake::Task['engine_cart:clean'].invoke
    Rake::Task['engine_cart:generate'].invoke
    Rake::Task['spec:all'].invoke
  end
end

begin
  Rake::Task['default'].clear
rescue RuntimeError
  # This isn't a big deal if we don't have a default
end

Rake::Task['spec'].clear

task spec: 'spec:all'
task default: 'spec:travis'

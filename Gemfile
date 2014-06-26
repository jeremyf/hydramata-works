source "https://rubygems.org"

# Declare your gem's dependencies in hydramata-work.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec path: File.expand_path('..', __FILE__)

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'

gem 'equivalent-xml', github: 'jeremyf/equivalent-xml', branch: 'updating-rspec-for-rspec-3'
gem "rake"
gem 'coveralls', require: false
if ! ENV['TRAVIS']
  gem 'simplecov', require: false
  gem 'guard-rspec'
  gem 'pry'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'rb-fsevent'
  gem 'terminal-notifier-guard'
  gem 'sexp_processor'
  gem 'ruby_parser'
end

file = File.expand_path("Gemfile", ENV['ENGINE_CART_DESTINATION'] || ENV['RAILS_ROOT'] || File.expand_path("../spec/internal", __FILE__))
if File.exists?(file)
  puts "Loading #{file} ..." if $DEBUG # `ruby -d` or `bundle -v`
  instance_eval File.read(file)
end

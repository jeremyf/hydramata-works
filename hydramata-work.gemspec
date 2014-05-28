$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'hydramata/work/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = 'hydramata-work'
  s.version     = Hydramata::Work::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Hydramata::Work."
  s.description = "TODO: Description of Hydramata::Work."

  s.license = 'APACHE2'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) do |f|
    f == 'bin/rails' ? nil : File.basename(f)
  end.compact
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec'


  s.add_dependency "rails", "~> 4.0.5"

  s.add_development_dependency "sqlite3"
end

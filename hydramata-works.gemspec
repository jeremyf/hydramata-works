$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'hydramata/works/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = 'hydramata-works'
  s.version     = Hydramata::Works::VERSION
  s.authors     = [
    'Jeremy Friesen'
  ]
  s.email       = [
    'jeremy.n.friesen@gmail.com'
  ]
  s.homepage    = 'https://ndlib.github.io/hydramata-works'
  s.summary     = 'Provide a well defined data-structure to ease the interaction between differing layers of a Hydra application.'
  s.description = 'Provide a well defined data-structure to ease the interaction between differing layers of a Hydra application.'
  s.required_ruby_version = '~> 2.0'

  s.license = 'APACHE2'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) do |f|
    f == 'bin/rails' ? nil : File.basename(f)
  end.compact
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency "rails", "~> 4.0"
  s.add_dependency 'rdf', '~> 1.1'
  s.add_dependency 'psych', '~> 2.0.5'
  s.add_dependency 'dragonfly', '~> 1.0'

  s.add_development_dependency 'engine_cart', '~> 0.3'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rspec-rails', '~> 3.0'
  s.add_development_dependency 'rspec-given', '~> 3.5'
  s.add_development_dependency 'rspec-html-matchers', '~>0.6'
  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'rubydora', '~> 1.7'
  s.add_development_dependency 'vcr', '~> 2.9'
  s.add_development_dependency 'webmock', '~> 1.18'
  s.add_development_dependency 'database_cleaner', '~> 1.3'
end

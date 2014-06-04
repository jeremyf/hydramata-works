$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'hydramata/work/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = 'hydramata-work'
  s.version     = Hydramata::Work::VERSION
  s.authors     = [
    'Jeremy Friesen'
  ]
  s.email       = [
    'jeremy.n.friesen@gmail.com'
  ]
  s.homepage    = 'https://github.com/jeremyf/hydramata-work'
  s.summary     = 'A Thought Experiement on Modeling Hydramata::Work'
  s.description = 'A Thought Experiement on Modeling Hydramata::Work'

  s.license = 'APACHE2'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) do |f|
    f == 'bin/rails' ? nil : File.basename(f)
  end.compact
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'rails', '~> 4.0.3'

  s.add_development_dependency 'engine_cart'
  s.add_development_dependency 'rspec', '~> 2.99'
  s.add_development_dependency 'rspec-html-matchers'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rubydora'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end

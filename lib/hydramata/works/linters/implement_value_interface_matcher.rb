require 'rspec/matchers'
require 'hydramata/works/linters/interface_matcher_builder'

RSpec::Matchers.define :implement_value_interface do
  Hydramata::Works::Linters::InterfaceMatcherBuilder.call(
    self, 'Value', [:raw_object]
  )
end

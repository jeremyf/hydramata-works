require 'rspec/matchers'
require 'hydramata/work/linters/interface_matcher_builder'

RSpec::Matchers.define :implement_value_interface do
  Hydramata::Work::Linters::InterfaceMatcherBuilder.call(
    self, 'Value', [:raw_object]
  )
end

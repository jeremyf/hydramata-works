require 'rspec/matchers'
require 'hydramata/works/linters/interface_matcher_builder'

RSpec::Matchers.define :implement_property_set_interface do
  Hydramata::Works::Linters::InterfaceMatcherBuilder.call(
    self, 'PropertySet', [:<<, :[], :predicates, :fetch, :==, :each, :subset]
  )
end

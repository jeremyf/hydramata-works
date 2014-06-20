# RSpec matcher to spec delegations.
require 'rspec/matchers'

RSpec::Matchers.define :implement_property_set_interface do
  Hydramata::Work::Linters::InterfaceMatcherBuilder.call(
    self, 'PropertySet', [:<<, :[], :predicates, :fetch, :==, :each, :subset]
  )
end

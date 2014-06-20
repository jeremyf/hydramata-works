# RSpec matcher to spec delegations.
require 'rspec/matchers'

RSpec::Matchers.define :implement_predicate_set_interface do
  Hydramata::Work::Linters::InterfaceMatcherBuilder.call(
    self, 'PredicateSet', [:work_type, :identity, :presentation_sequence, :name_for_application_usage, :predicates]
  )
end

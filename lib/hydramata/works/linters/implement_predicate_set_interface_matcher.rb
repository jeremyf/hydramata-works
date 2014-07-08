require 'rspec/matchers'
require 'hydramata/works/linters/interface_matcher_builder'

RSpec::Matchers.define :implement_predicate_set_interface do
  Hydramata::Works::Linters::InterfaceMatcherBuilder.call(
    self, 'PredicateSet', [:work_type, :identity, :presentation_sequence, :name_for_application_usage, :predicates]
  )
end

require 'rspec/matchers'
require 'hydramata/work/linters/interface_matcher_builder'

RSpec::Matchers.define :implement_work_type_interface do
  Hydramata::Work::Linters::InterfaceMatcherBuilder.call(
    self,
    'WorkType',
    identity: [],
    name_for_application_usage: [],
    predicate_sets: [:each],
    itemtype_schema_dot_org: []
  )
end

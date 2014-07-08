require 'rspec/matchers'
require 'hydramata/works/linters/interface_matcher_builder'

RSpec::Matchers.define :implement_predicate_interface do
  Hydramata::Works::Linters::InterfaceMatcherBuilder.call(
    self,
    'Predicate',
    identity: [],
    name_for_application_usage: [],
    datastream_name: [],
    value_coercer_name: [],
    value_parser_name: [],
    validations: [],
    indexing_strategy: [],
    itemprop_schema_dot_org: []
  )
end

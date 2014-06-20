require 'rspec/matchers'
require 'hydramata/work/linters/interface_matcher_builder'

RSpec::Matchers.define :implement_predicate_interface do
  Hydramata::Work::Linters::InterfaceMatcherBuilder.call(
    self,
    'DataDefinition',
    [
      :identity,
      :name_for_application_usage,
      :datastream_name,
      :value_coercer_name,
      :value_parser_name,
      :indexing_strategy
    ]
  )
end

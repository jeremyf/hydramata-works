require 'rspec/matchers'
require 'hydramata/work/linters/interface_matcher_builder'

RSpec::Matchers.define :implement_data_definition_interface do
  Hydramata::Work::Linters::InterfaceMatcherBuilder.call(
    self,
    'DataDefinition',
    [
      :identity,
      :identity=,
      :name_for_application_usage,
      '<=>',
      :name_for_application_usage=
    ]
  )
end

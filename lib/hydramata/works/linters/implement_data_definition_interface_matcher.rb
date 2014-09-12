require 'rspec/matchers'
require 'hydramata/works/linters/interface_matcher_builder'

RSpec::Matchers.define :implement_data_definition_interface do
  Hydramata::Works::Linters::InterfaceMatcherBuilder.call(
    self,
    'DataDefinition',
    [
      :identity,
      :identity=,
      :name_for_application_usage,
      '<=>',
      :to_sym,
      :name_for_application_usage=,
      :to_translation_key_fragment,
      :translation_key_fragment=,
      :translation_key_fragment,
      :to_view_path_fragment,
      :view_path_fragment=,
      :view_path_fragment
    ]
  )
end

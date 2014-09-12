require 'rspec/matchers'
require 'hydramata/works/linters/interface_matcher_builder'

RSpec::Matchers.define :implement_property_interface do
  Hydramata::Works::Linters::InterfaceMatcherBuilder.call(
    self,
    'Property',
    :name => [],
    :each => [],
    :<< => [],
    :replace_values => [],
    :append_values => [],
    :values => [:each],
    :predicate => [],
    :to_translation_key_fragment => [],
    :to_view_path_fragment => []
  )
end

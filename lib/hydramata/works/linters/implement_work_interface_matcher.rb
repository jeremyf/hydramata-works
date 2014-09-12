require 'rspec/matchers'
require 'hydramata/works/linters/interface_matcher_builder'

RSpec::Matchers.define :implement_work_interface do
  Hydramata::Works::Linters::InterfaceMatcherBuilder.call(
    self,
    'Work',
    properties: [:<<, :each, :fetch, :[]],
    has_property?: [],
    name_for_application_usage: [],
    work_type: [],
    identity: [],
    to_translation_key_fragment: [],
    to_view_path_fragment: [],
    itemtype_schema_dot_org: []
  )
end

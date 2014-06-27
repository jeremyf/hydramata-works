require 'rspec/matchers'
require 'hydramata/work/linters/interface_matcher_builder'

RSpec::Matchers.define :implement_entity_interface do
  Hydramata::Work::Linters::InterfaceMatcherBuilder.call(
    self,
    'Entity',
    properties: [:<<, :each, :fetch, :[]],
    has_property?: [],
    name_for_application_usage: [],
    work_type: [],
    identity: [],
    to_translation_key_fragment: [],
    itemtype_schema_dot_org: []
  )
end

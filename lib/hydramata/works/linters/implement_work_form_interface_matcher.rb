require 'rspec/matchers'
require 'hydramata/works/linters/interface_matcher_builder'

RSpec::Matchers.define :implement_work_form_interface do
  Hydramata::Works::Linters::InterfaceMatcherBuilder.call(
    self,
    'WorkForm',
    errors: [:each],
    to_key: [],
    to_param: [],
    to_partial_path: [],
    persisted?: [],
    valid?: []
  )
end

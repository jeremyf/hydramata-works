require 'rspec/matchers'
require 'hydramata/works/linters/interface_matcher_builder'

RSpec::Matchers.define :implement_work_presenter_interface do
  Hydramata::Works::Linters::InterfaceMatcherBuilder.call(
    self,
    'WorkPresenter',
    render: [],
    translate: [],
    t: []
  )
end

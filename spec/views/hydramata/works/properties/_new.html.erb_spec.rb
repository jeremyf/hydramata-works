# @TODO - restore this to spec_view_helper
# There is a dependency when looking up property and works.
require 'spec_slow_helper'

# As of 3.0.x :type tags are no longer inferred.
# This means, without the `type: :view` tag, the render method does not exist
# in the example context
describe 'hydramata/works/properties/_new.html.erb', type: :view do
  let(:work) { Hydramata::Works::Work.new(identity: 'article') }
  let(:predicate) { Hydramata::Works::Predicate.new(identity: 'dc_title') }
  let(:property) { Hydramata::Works::Property.new(predicate: predicate, values: ['value1', 'value2']) }
  let(:presenter) { Hydramata::Works::PropertyPresenter.new(property: property, work: work) }
  let(:form) { double('Form') }

  it 'renders the object and fieldsets' do
    allow(presenter).to receive(:with_text_for).with(:help).and_yield('This is a hint')
    render partial: 'hydramata/works/properties/new', object: presenter, locals: { form: form }

    expect(rendered).to have_tag('.dc-title') do
      with_tag('label', text: presenter.label)
      with_tag('.values input#work_dc_title_0.blank-input', with: { name: 'work[dc_title][]' })
      with_tag('.values input#work_dc_title_1.existing-input', with: { name: 'work[dc_title][]', value: 'value1' })
      with_tag('.values input#work_dc_title_2.existing-input', with: { name: 'work[dc_title][]', value: 'value2' })
      with_tag('.help-block', text: 'This is a hint')
    end
  end
end

# @TODO - restore this to spec_view_helper
# There is a dependency when looking up property and works.
require 'spec_slow_helper'

# As of 3.0.x :type tags are no longer inferred.
# This means, without the `type: :view` tag, the render method does not exist
# in the example context
describe 'hydramata/works/properties/attachment/_new.html.erb', type: :view do
  let(:work) { Hydramata::Works::Work.new(identity: 'article') }
  let(:predicate) { Hydramata::Works::Predicate.new(identity: 'attachment') }
  let(:property) { Hydramata::Works::Property.new(predicate: predicate) }
  let(:presenter) { Hydramata::Works::PropertyPresenter.new(property: property, work: work) }
  let(:form) { double('Form') }

  it 'renders the object and fieldsets' do
    allow(presenter).to receive(:with_text_for).with(:help).and_yield('This is a hint')
    render partial: 'hydramata/works/properties/attachment/new', object: presenter, locals: { form: form }

    expect(rendered).to have_tag('.attachment') do
      with_tag('label', text: presenter.label)
      with_tag(
        '.values input#work_attachment_0.blank-input',
        with: { type: 'file', multiple: 'multiple', name: 'work[attachment][]' }
      )
      with_tag('.help-block', text: 'This is a hint')
    end
  end
end

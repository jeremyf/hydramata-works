require 'spec_view_helper'

# As of 3.0.x :type tags are no longer inferred.
# This means, without the `type: :view` tag, the render method does not exist
# in the example context
describe 'hydramata/works/properties/attachment/_edit.html.erb', type: :view do
  let(:object) { double('Object', predicate: 'attachment', dom_class: 'my-dom-class') }
  let(:form) { double('Form') }

  it 'renders the object and fieldsets' do
    expect(object).to receive(:label).and_return('Label')
    render partial: 'hydramata/works/properties/attachment/edit', object: object, locals: { form: form }

    expect(rendered).to have_tag('.my-dom-class') do
      with_tag('label', text: 'Label')
      with_tag('.values input#work_attachment_0.blank-input', with: { type: 'file', multiple: 'multiple', name: 'work[attachment][]' })
    end
  end
end
require 'spec_view_helper'

# As of 3.0.x :type tags are no longer inferred.
# This means, without the `type: :view` tag, the render method does not exist
# in the example context
describe 'hydramata/works/properties/_edit.html.erb', type: :view do
  let(:object) { double('Object', predicate: 'my_predicate', t: true, dom_class: 'my-dom-class') }
  let(:form) { double('Form') }

  it 'renders the object and fieldsets' do
    expect(object).to receive(:each_with_index).and_yield('value1', 0).and_yield('value2', 1)
    expect(object).to receive(:label).and_return('Label')
    render partial: 'hydramata/works/properties/edit', object: object, locals: { form: form }

    expect(rendered).to have_tag('.my-dom-class') do
      with_tag('label', text: 'Label')
      with_tag('.values input#work_my_predicate_0.blank-input', with: { name: 'work[my_predicate][]' })
      with_tag('.values input#work_my_predicate_1.existing-input', with: { name: 'work[my_predicate][]', value: 'value1' })
      with_tag('.values input#work_my_predicate_2.existing-input', with: { name: 'work[my_predicate][]', value: 'value2' })
    end
  end
end
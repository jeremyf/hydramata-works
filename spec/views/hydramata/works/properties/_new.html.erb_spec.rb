require 'spec_view_helper'

# As of 3.0.x :type tags are no longer inferred.
# This means, without the `type: :view` tag, the render method does not exist
# in the example context
describe 'hydramata/works/properties/_new.html.erb', type: :view do
  let(:object) { double('Object', predicate: 'my_predicate', t: true, dom_class: 'my-dom-class') }
  let(:form) { double('Form') }

  it 'renders the object and fieldsets' do
    expect(object).to receive(:each_with_index).and_yield('value1', 0).and_yield('value2', 1)
    expect(object).to receive(:with_text_for).with(:help).and_yield('This is a hint')
    expect(object).to receive(:label).and_return('Label')

    expect(object).to receive(:dom_id_for_label).and_return('label_dom_id').at_least(:once)
    expect(object).to receive(:dom_label_attributes).and_return({ id: 'label_dom_id' })
    expect(object).to receive(:dom_name_for_field).and_return('work[my_predicate][]').at_least(:once)

    expect(object).to receive(:dom_id_for_field).with(index: 1).and_return('work_my_predicate_1')
    expect(object).to receive(:dom_id_for_field).with(index: 2).and_return('work_my_predicate_2')
    expect(object).to receive(:dom_id_for_field).with(no_args).and_return('work_my_predicate_0').at_least(:once)

    render partial: 'hydramata/works/properties/new', object: object, locals: { form: form }

    expect(rendered).to have_tag('.my-dom-class') do
      with_tag('label', text: 'Label')
      with_tag('.values input#work_my_predicate_0.blank-input', with: { name: 'work[my_predicate][]' })
      with_tag('.values input#work_my_predicate_1.existing-input', with: { name: 'work[my_predicate][]', value: 'value1' })
      with_tag('.values input#work_my_predicate_2.existing-input', with: { name: 'work[my_predicate][]', value: 'value2' })
      with_tag('.help-block', text: 'This is a hint')
    end
  end
end

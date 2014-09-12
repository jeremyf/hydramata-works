require 'spec_view_helper'

# As of 3.0.x :type tags are no longer inferred.
# This means, without the `type: :view` tag, the render method does not exist
# in the example context
describe 'hydramata/works/properties/_show.html.erb', type: :view do
  let(:value1) { double('Value 1', render: '<dd class="my-dom-class value">value1</dd>'.html_safe ) }
  let(:value2) { double('Value 2', render: '<dd class="my-dom-class value">value2</dd>'.html_safe ) }
  let(:object) do
    double(
      'Object',
      predicate: 'title',
      dom_label_attributes: {
        'id' => "label_for_work_title",
        'class' => ['my-dom-class', 'label']
      },
      dom_value_attributes: {
        "aria-labelledby"=>"label_for_work_title",
        'class' => ['my-dom-class', 'value']
      },
      values: [value1, value2]
    )
  end

  it 'renders the object and fieldsets' do
    expect(object).to receive(:label).and_return('Label')
    render partial: 'hydramata/works/properties/show', object: object

    expect(rendered).to have_tag('#label_for_work_title.my-dom-class.label', text: 'Label')
    expect(rendered).to have_tag('.my-dom-class.value[aria-labelledby="label_for_work_title"]', text: 'value1')
    expect(rendered).to have_tag('.my-dom-class.value[aria-labelledby="label_for_work_title"]', text: 'value2')

  end
end

require 'slow_spec_helper'

# As of 3.0.x :type tags are no longer inferred.
# This means, without the `type: :view` tag, the render method does not exist
# in the example context
describe 'hydramata/work/properties/_show.html.erb', type: :view do
  let(:object) { double('Object', t: true, dom_class: 'my-dom-class') }

  it 'renders the object and fieldsets' do
    expect(object).to receive(:each).and_yield('value1').and_yield('value2')
    expect(object).to receive(:t).with(:name).and_return('Label')
    render partial: 'hydramata/work/properties/show', object: object

    expect(rendered).to have_tag('div.my-dom-class') do
      with_tag('.label', text: 'Label')
      with_tag('.value', text: 'value1')
      with_tag('.value', text: 'value2')
    end
  end
end
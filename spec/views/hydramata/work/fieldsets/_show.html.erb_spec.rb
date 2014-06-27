require 'spec_view_helper'

# As of 3.0.x :type tags are no longer inferred.
# This means, without the `type: :view` tag, the render method does not exist
# in the example context
describe 'hydramata/work/fieldsets/_show.html.erb', type: :view do
  let(:object) { double('Object', t: true, properties: [property1, property2],  container_content_tag_attributes: { class: 'my-dom-class' } ) }

  # A short circuit as the render does not normally
  let(:property1) { double('Property', render: '<div class="property1">Property 1</div>'.html_safe) }
  let(:property2) { double('Property', render: '<div class="property2">Property 2</div>'.html_safe) }

  it 'renders the object and fieldsets' do
    expect(object).to receive(:t).with(:name).and_return('Heading')
    render partial: 'hydramata/work/fieldsets/show', object: object

    expect(property1).to have_received(:render).with(template: view)
    expect(property2).to have_received(:render).with(template: view)
    expect(rendered).to have_tag('section.my-dom-class') do
      with_tag('.heading', text: 'Heading')
      with_tag('.metadata .property1', text: 'Property 1')
      with_tag('.metadata .property2', text: 'Property 2')
    end
  end
end
require 'spec_view_helper'

# As of 3.0.x :type tags are no longer inferred.
# This means, without the `type: :view` tag, the render method does not exist
# in the example context
describe 'hydramata/works/fieldsets/_new.html.erb', type: :view do
  let(:form) { double('Form') }
  let(:object) { double('Object', fieldsets: [fieldset1, fieldset2], dom_class: 'my-dom-class') }

  let(:object) { double('Object', t: true, properties: [property1, property2], dom_class: 'my-dom-class') }

  # A short circuit as the render does not normally
  let(:property1) { double('Property', render: '<div class="property1">Property 1</div>'.html_safe) }
  let(:property2) { double('Property', render: '<div class="property2">Property 2</div>'.html_safe) }

  it 'renders the object and fieldsets' do
    expect(object).to receive(:label).and_return('Heading')
    render partial: 'hydramata/works/fieldsets/new', object: object, locals: { form: form }

    expect(property1).to have_received(:render).with(template: view, locals: { form: form } )
    expect(property2).to have_received(:render).with(template: view, locals: { form: form } )
    expect(rendered).to have_tag('fieldset.my-dom-class.fieldset') do
      with_tag('caption', text: 'Heading')
      with_tag('.property1', text: 'Property 1')
      with_tag('.property2', text: 'Property 2')
    end
  end

end
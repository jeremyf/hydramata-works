require 'spec_view_helper'

# As of 3.0.x :type tags are no longer inferred.
# This means, without the `type: :view` tag, the render method does not exist
# in the example context
describe 'hydramata/works/works/_show.html.erb', type: :view do
  let(:dom_attributes) { { class: ['work', 'my-dom-class'] } }
  let(:object) { double('Object', fieldsets: [fieldset1, fieldset2], container_content_tag_attributes: dom_attributes) }

  # A short circuit as the render does not normally
  let(:fieldset1) { double('Fieldset', render: '<div class="set1">Fieldset 1</div>'.html_safe) }
  let(:fieldset2) { double('Fieldset', render: '<div class="set2">Fieldset 2</div>'.html_safe) }

  it 'renders the object and fieldsets' do
    render partial: 'hydramata/works/works/show', object: object

    expect(fieldset1).to have_received(:render).with(template: view)
    expect(fieldset2).to have_received(:render).with(template: view)
    expect(rendered).to have_tag('article.work.my-dom-class') do
      with_tag('.set1', text: 'Fieldset 1')
      with_tag('.set2', text: 'Fieldset 2')
    end
  end
end
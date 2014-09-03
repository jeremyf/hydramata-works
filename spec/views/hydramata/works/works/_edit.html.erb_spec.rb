require 'spec_view_helper'

# As of 3.0.x :type tags are no longer inferred.
# This means, without the `type: :view` tag, the render method does not exist
# in the example context
describe 'hydramata/works/works/_edit.html.erb', type: :view do
  let(:object) { double('Object', form_options: {}, fieldsets: [fieldset1, fieldset2], actions: [action], dom_class: 'my-dom-class') }

  # A short circuit as the render does not normally
  let(:fieldset1) { double('Fieldset', render: '<div class="set1">Fieldset 1</div>'.html_safe) }
  let(:fieldset2) { double('Fieldset', render: '<div class="set2">Fieldset 2</div>'.html_safe) }
  let(:action) { double('Action', render: '<div class="action">An Action</div>'.html_safe) }

  it 'renders the object and fieldsets' do
    render partial: 'hydramata/works/works/edit', object: object

    expect(fieldset1).to have_received(:render).with(template: view, locals: { form: kind_of(ActionView::Helpers::FormBuilder) })
    expect(fieldset2).to have_received(:render).with(template: view, locals: { form: kind_of(ActionView::Helpers::FormBuilder) })
    expect(rendered).to have_tag('form.work.my-dom-class') do
      with_tag('.set1', text: 'Fieldset 1')
      with_tag('.set2', text: 'Fieldset 2')
      with_tag('.actions .action', text: 'An Action')
    end
  end
end
require 'spec_view_helper'

# As of 3.0.x :type tags are no longer inferred.
# This means, without the `type: :view` tag, the render method does not exist
# in the example context
describe 'hydramata/works/values/attachment/_show.html.erb', type: :view do
  let(:object) { double('Object', label: 'readme.txt') }

  it 'renders the object and fieldsets' do
    render partial: 'hydramata/works/values/attachment/show', object: object

    expect(rendered).to have_tag('a', text: object.label)

  end
end
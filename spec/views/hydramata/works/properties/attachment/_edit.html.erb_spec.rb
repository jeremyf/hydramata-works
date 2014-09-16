# @TODO - restore this to spec_view_helper
# There is a dependency when looking up property and works.
require 'spec_slow_helper'

# As of 3.0.x :type tags are no longer inferred.
# This means, without the `type: :view` tag, the render method does not exist
# in the example context
describe 'hydramata/works/properties/attachment/_new.html.erb', type: :view do
  let(:work) { Hydramata::Works::Work.new(identity: 'article') }
  let(:predicate) { Hydramata::Works::Predicate.new(identity: 'attachment') }
  let(:property) { Hydramata::Works::Property.new(predicate: predicate, values: [attachment_1, attachment_2]) }
  let(:object) { Hydramata::Works::PropertyPresenter.new(property: property, work: work) }
  let(:form) { double('Form') }
  let(:attachment_1) { double('Attachment', to_s: 'file_1.txt', to_param: '123') }
  let(:attachment_2) { double('Attachment', to_s: 'file_2.txt', to_param: '456') }

  it 'renders the object and fieldsets' do
    expect(object).to receive(:with_text_for).with(:help).and_yield('This is a hint')

    render partial: 'hydramata/works/properties/attachment/edit', object: object, locals: { form: form }

    expect(rendered).to have_tag('.attachment') do
      with_tag('#label_for_work_attachment', text: 'attachment')
      [attachment_1, attachment_2].each_with_index do |attachment, i|
        index = i+1
        with_tag(".values .value") do
          with_tag(
            '.existing-input', text: attachment.to_s,
            with: { 'aria-labelledby' => 'label_for_work_attachment' }
          )
          with_tag('.existing-input-delete') do
            with_tag(
              "label.existing-input-delete-label#label_for_work_attachment_delete_#{index}",
              text: "Delete #{attachment}",
              with: { for: "work_#{object.predicate}_delete_#{index}"}
            )
            with_tag(
              ".existing-input-delete-input#work_#{object.predicate}_delete_#{index}",
              with: {
                :type => :checkbox, :name => 'work[attachment][delete][]', :value => attachment.to_param,
                'aria-labelledby' => "label_for_work_attachment_delete_#{index}"
              },
              without: { checked: true }
            )
          end
        end

        with_tag(
          '.values .value input#work_attachment_0.blank-input',
          with: {
            :type => 'file', :name => 'work[attachment][add][]',
            'aria-labelledby' => 'label_for_work_attachment'
          }
        )
        with_tag('.help-block', text: 'This is a hint')

      end
    end
  end
end

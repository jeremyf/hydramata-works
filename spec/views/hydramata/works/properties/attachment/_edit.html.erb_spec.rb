require 'spec_view_helper'

# As of 3.0.x :type tags are no longer inferred.
# This means, without the `type: :view` tag, the render method does not exist
# in the example context
describe 'hydramata/works/properties/attachment/_edit.html.erb', type: :view do
  let(:object) { double('Object', predicate: 'attachment', dom_class: 'my-dom-class', label: 'Label') }
  let(:form) { double('Form') }
  let(:attachment_1) { double('Attachment', to_s: 'file_1.txt', to_param: '123') }
  let(:attachment_2) { double('Attachment', to_s: 'file_2.txt', to_param: '456') }

  it 'renders the object and fieldsets' do
    expect(object).to receive(:each_with_index).and_yield(attachment_1, 0).and_yield(attachment_2, 1)
    expect(object).to receive(:with_text_for).with(:help).and_yield('This is a hint')

    render partial: 'hydramata/works/properties/attachment/edit', object: object, locals: { form: form }

    expect(rendered).to have_tag('.my-dom-class') do
      with_tag('label', text: 'Label')
      [attachment_1, attachment_2].each_with_index do |attachment, i|
        index = i+1
        with_tag(".values .value#work_attachment_#{index}") do
          with_tag(
            '.existing-input', text: attachment.to_s,
            with: { 'aria-labelledby' => 'label_for_work_attachment' }
          )
          with_tag('.existing-input-delete') do
            with_tag(
              "label.existing-input-delete-label#label_for_delete_work_attachment_#{index}",
              text: "Delete #{attachment}",
              with: { for: "delete_work_#{object.predicate}_#{index}"}
            )
            with_tag(
              ".existing-input-delete-input#delete_work_#{object.predicate}_#{index}",
              with: {
                :type => :checkbox, :name => 'work[attachment][delete][]', :value => attachment.to_param,
                'aria-labelledby' => "label_for_delete_work_attachment_#{index}"
              },
              without: { checked: true }
            )
          end
        end

        with_tag(
          '.values .value input#work_attachment_0.blank-input',
          with: {
            :type => 'file', :multiple => 'multiple', :name => 'work[attachment][add][]',
            'aria-labelledby' => 'label_for_work_attachment'
          }
        )
        with_tag('.help-block', text: 'This is a hint')

      end
    end
  end
end

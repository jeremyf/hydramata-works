require 'spec_slow_helper'
require 'spec_file_upload_helper'
require 'hydramata/works/service_methods'
require 'hydramata/works/linters/implement_work_interface_matcher'
require 'hydramata/works/linters/implement_work_presenter_interface_matcher'
require 'hydramata/works/linters/implement_work_type_presenter_interface_matcher'
require 'hydramata/works/linters/implement_work_form_interface_matcher'
require 'hydramata/works/conversions/work_type'

module Hydramata
  module Works
    describe ServiceMethods do
      include Conversions

      Given(:service) do
        Class.new do
          include ServiceMethods
        end.new
      end

      context '#new_work_for' do
        before do
          load File.expand_path('../../../../support/feature_seeds.rb', __FILE__)
        end
        Given(:work_type) { 'article' }
        Given(:attributes) { { dc_title: 'my title' } }
        When(:returned_object) { service.new_work_for(work_type, attributes) }
        Then{ expect(returned_object).to implement_work_interface }
        And { expect(returned_object).to implement_work_presenter_interface }
        And { expect(returned_object).to implement_work_form_interface }
        And { expect(returned_object).to be_an_instance_of(WorkForm) }
        And { expect(returned_object).to be_an_instance_of(WorkPresenter) }
        And { expect(returned_object).to be_an_instance_of(Work) }
        And { expect(returned_object.presentation_context).to eq(:new) }
        And { expect(returned_object.properties[:dc_title]).to eq(Property.new(predicate: 'dc_title', values: 'my title')) }
        And { expect(returned_object.actions.count).to eq(1) }
      end

      context '#available_work_types' do
        before do
          load File.expand_path('../../../../support/feature_seeds.rb', __FILE__)
        end

        When(:returned_object) { service.available_work_types }
        Then { expect(returned_object).to eq([WorkType('article'), WorkType('book')]) }
        And { expect(returned_object[0]).to implement_work_type_presenter_interface }
        And { expect(returned_object[1]).to implement_work_type_presenter_interface }
      end

      context '#save_work' do
        before do
          load File.expand_path('../../../../support/feature_seeds.rb', __FILE__)
        end
        Given(:work_type) { 'article' }
        Given(:work) { service.new_work_for(work_type, attributes) }
        context 'valid data' do
          Given(:attributes) { { dc_title: 'my title' } }
          When(:response) { service.save_work(work) }
          Then { response == 'valid' }
          And { work.new_record? == false }
          And { work.errors.empty? }
          And { service.find_work(work.identity).state == 'valid' }
          And { service.find_work(work.identity).properties[:dc_title].values == ['my title'] }
        end
        context 'with attachment' do
          Given(:attributes) do
            {
              attachment: [FileUpload.fixture_file_upload('attachments/hello-world.txt')]
            }
          end
          Given(:uploaded_attachment) { service.find_work(work.identity).properties[:attachment].values.first }
          When(:response) { service.save_work(work) }
          Then { expect(uploaded_attachment.raw_object.file.name).to eq('hello-world.txt') }
          And { expect(uploaded_attachment.raw_object.file.data).to eq(FileUpload.pathname_for('attachments/hello-world.txt').read) }
        end
        context 'invalid data' do
          Given(:attributes) { { dc_title: '' } }
          When(:response) { service.save_work(work) }
          Then { response == 'invalid' }
          And { work.new_record? == false }
          And { work.errors.present? }
          And { service.find_work(work.identity).state == 'invalid' }
        end
      end

      context '#find_work' do
        before do
          load File.expand_path('../../../../support/feature_seeds.rb', __FILE__)
        end
        Given(:work_type) { 'article' }
        Given(:attributes) { { dc_title: 'my title' } }
        Given(:work) { service.new_work_for(work_type, attributes).tap {|obj| service.save_work(obj) } }
        When(:found_object) { service.find_work(work.identity) }
        Then { found_object.identity == work.identity }
        And { found_object.object_id != work.object_id }
        And { found_object.properties == work.properties }
        And { expect(found_object).to implement_work_presenter_interface }
        And { found_object.presentation_context == :show }
        And { found_object.actions.all? {|action| action.instance_of?(ActionPresenter) } }
      end

      context '#edit_work' do
        before do
          load File.expand_path('../../../../support/feature_seeds.rb', __FILE__)
        end
        Given(:work_type) { 'article' }
        Given(:attributes) { { dc_title: 'my title' } }
        Given(:work) { service.new_work_for(work_type, attributes).tap {|obj| service.save_work(obj) } }
        When(:editable_work) { service.edit_work(work.identity) }
        Then { editable_work.identity == work.identity }
        And { editable_work.object_id != work.object_id }
        And { editable_work.properties == work.properties }
        And { expect(editable_work).to implement_work_presenter_interface }
        And { expect(editable_work).to implement_work_form_interface }
        And { expect(editable_work.presentation_context).to eq(:edit) }
        # And { found_object == work } # TODO: Does this make sense?
      end

      context 'sequence of services to create and update a work' do
        before do
          load File.expand_path('../../../../support/feature_seeds.rb', __FILE__)
        end

        Given(:work_type) { 'article' }
        Given(:new_attributes) do
          {
            dc_title: [''],
            dc_abstract: ['My Abstract'],
            attachment: [
              FileUpload.fixture_file_upload('attachments/hello-world.txt'),
              add: FileUpload.fixture_file_upload('attachments/good-bye-world.txt')
            ]
          }
        end
        Given(:edit_attributes) do
          {
            dc_title: ['My Title'],
            dc_abstract: ['Ye Ol\' Abstract', 'Another Abstract'],
            attachment: {
              add: [FileUpload.fixture_file_upload('attachments/another-attachment.txt')],
              delete: []
            }
          }
        end

        it 'captures the correct metadata' do
          work = service.new_work_for(work_type, new_attributes)
          service.save_work(work)

          expect(work.properties['attachment'].values.map(&:to_s)).to eq(['hello-world.txt', 'good-bye-world.txt'])
          expect(work.properties['dc_title'].values.map(&:to_s)).to eq([])
          expect(work.properties['dc_abstract'].values.map(&:to_s)).to eq(['My Abstract'])

          # Get the handle for the attachment that I want to dettach
          found_work = service.find_work(work.identity)
          first_uploaded_attachment = found_work.properties['attachment'].values.first.to_param
          edit_attributes[:attachment][:delete] << first_uploaded_attachment
          edited_work = service.edit_work(work.identity, edit_attributes)
          service.save_work(edited_work)

          expect(edited_work.identity).to eq(work.identity)

          updated_work = service.find_work(edited_work.identity)

          expect(updated_work.properties['dc_title'].values.map(&:to_s)).to eq(['My Title'])
          expect(updated_work.properties['dc_abstract'].values.map(&:to_s)).to eq(['Ye Ol\' Abstract', 'Another Abstract'])
          expect(updated_work.properties['attachment'].values.map(&:to_s)).to eq(['good-bye-world.txt', 'another-attachment.txt'])
        end
      end
    end
  end
end

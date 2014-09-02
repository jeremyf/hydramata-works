require 'spec_active_record_helper'
require 'hydramata/works/service_methods'
require 'hydramata/works/property'
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

    end
  end
end

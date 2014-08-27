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
      Given(:context) { double('Context') }

      context '#new_work_for' do
        before do
          load File.expand_path('../../../../support/feature_seeds.rb', __FILE__)
        end
        Given(:work_type) { 'article' }
        Given(:attributes) { { dc_title: 'my title' } }
        When(:returned_object) { service.new_work_for(context, work_type, attributes) }
        Then{ expect(returned_object).to implement_work_interface }
        And { expect(returned_object).to implement_work_presenter_interface }
        And { expect(returned_object).to implement_work_form_interface }
        And { expect(returned_object).to be_an_instance_of(WorkForm) }
        And { expect(returned_object).to be_an_instance_of(WorkPresenter) }
        And { expect(returned_object).to be_an_instance_of(Work) }
        And { expect(returned_object.properties[:dc_title]).to eq(Property.new(predicate: 'dc_title', values: 'my title')) }
        And { expect(returned_object.actions.count).to eq(1) }
      end

      context '#available_work_types' do
        before do
          load File.expand_path('../../../../support/feature_seeds.rb', __FILE__)
        end

        When(:returned_object) { service.available_work_types(context) }
        Then { expect(returned_object).to eq([WorkType('article'), WorkType('book')]) }
        And { expect(returned_object[0]).to implement_work_type_presenter_interface }
        And { expect(returned_object[1]).to implement_work_type_presenter_interface }
      end

      context '#save_work' do
        before do
          load File.expand_path('../../../../support/feature_seeds.rb', __FILE__)
        end
        Given(:work_type) { 'article' }
        Given(:attributes) { { dc_title: 'my title' } }
        Given(:work) { service.new_work_for(context, work_type, attributes) }
        When(:response) { service.save_work(work) }
        Then { response == true }
        And { work.new_record? == false }
      end

      context '#find_work' do
        before do
          load File.expand_path('../../../../support/feature_seeds.rb', __FILE__)
        end
        Given(:work_type) { 'article' }
        Given(:attributes) { { dc_title: 'my title' } }
        Given(:work) { service.new_work_for(context, work_type, attributes).tap {|obj| service.save_work(obj) } }
        When(:found_object) { service.find_work(work.identity) }
        Then { found_object.identity == work.identity }
        And { found_object.object_id != work.object_id }
        And { found_object.properties == work.properties }
        # And { found_object == work } # TODO: Does this make sense?
      end

    end
  end
end

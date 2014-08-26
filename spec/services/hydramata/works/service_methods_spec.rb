require 'spec_slow_helper'
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
      let(:service) do
        Class.new do
          include ServiceMethods
        end.new
      end
      let(:context) { double('Context') }
      context '#new_work_for' do
        let(:work_type) { 'article' }
        let(:attributes) { { title: 'my title' } }

        it 'should return a WorkForm' do
          returned_object = service.new_work_for(context, work_type, attributes)
          expect(returned_object).to implement_work_interface
          expect(returned_object).to implement_work_presenter_interface
          expect(returned_object).to implement_work_form_interface

          expect(returned_object).to be_an_instance_of(WorkForm)
          expect(returned_object).to be_an_instance_of(WorkPresenter)
          expect(returned_object).to be_an_instance_of(Work)
          expect(returned_object.properties[:title]).to eq(Property.new(predicate: :title, values: 'my title'))
          expect(returned_object.actions.count).to eq(1)
        end
      end

      context '#available_work_types' do
        before do
          WorkTypes::Storage.create(identity: 'book')
          WorkTypes::Storage.create(identity: 'article')
        end
        it 'should return an enumerable of work types' do
          returned_object = service.available_work_types(context)
          expect(returned_object).to eq([WorkType('article'), WorkType('book')])
          expect(returned_object[0]).to implement_work_type_presenter_interface
          expect(returned_object[1]).to implement_work_type_presenter_interface
        end
      end
    end
  end
end


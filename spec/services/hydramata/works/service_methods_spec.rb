require 'spec_slow_helper'
require 'hydramata/works/service_methods'
require 'hydramata/works/property'
require 'hydramata/works/linters/implement_work_interface_matcher'
require 'hydramata/works/linters/implement_work_presenter_interface_matcher'
require 'hydramata/works/linters/implement_work_form_interface_matcher'

module Hydramata
  module Works
    describe ServiceMethods do
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
    end
  end
end


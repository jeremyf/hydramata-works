require 'spec_fast_helper'
require 'hydramata/works/configuration_methods'

module Hydramata
  module Works
    describe ConfigurationMethods do
      Given(:configuration) do
        Class.new do
          include ConfigurationMethods
        end.new
      end
      context 'default #work_model_name' do
        When(:work_model_name) { configuration.work_model_name }
        Then { work_model_name == 'Work' }
      end
      context 'override #work_model_name' do
        Given(:work_model_name) { 'SomethingDifferent' }
        When { configuration.work_model_name = work_model_name }
        Then { configuration.work_model_name == work_model_name }
      end

      context 'default #work_storage_service' do
        When(:service) { configuration.work_storage_service }
        Then { service.respond_to?(:call) }
      end

      context 'override #work_storage_service' do
        it 'raises an exception when the object is invalid' do
          expect {
            configuration.work_storage_service = :storage_service
          }.to raise_error(RuntimeError)
        end

        Given(:service) { double(call: true) }
        When { configuration.work_storage_service = service }
        Then { configuration.work_storage_service == service }

      end
    end
  end
end

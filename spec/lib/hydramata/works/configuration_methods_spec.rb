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

      context '#work_model_name' do

        context 'default value' do
          When(:work_model_name) { configuration.work_model_name }
          Then { work_model_name == 'Work' }
        end

        context 'override' do
          Given(:work_model_name) { 'SomethingDifferent' }
          When { configuration.work_model_name = work_model_name }
          Then { configuration.work_model_name == work_model_name }
        end

      end

      context '#work_storage_service' do
        context 'default value' do
          When(:service) { configuration.work_storage_service }
          Then { service.respond_to?(:call) }
        end

        context 'override' do
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

      context '#pid_minting_service' do

        context 'default' do
          When(:service) { configuration.pid_minting_service }
          Then { service.respond_to?(:call) }
        end

        context 'override #pid_minting_service' do
          it 'raises an exception when the object is invalid' do
            expect {
              configuration.pid_minting_service = :storage_service
            }.to raise_error(RuntimeError)
          end

          Given(:service) { double(call: true) }
          When { configuration.pid_minting_service = service }
          Then { configuration.pid_minting_service == service }

        end
      end

      context '#repository_connection' do

        context 'default value' do
          When(:repository_connection) { configuration.repository_connection }
          Then { repository_connection.respond_to?(:find_or_initialize) }
        end

        context 'override' do
          it 'raises an exception when the object is invalid' do
            expect {
              configuration.repository_connection = :repository_connection
            }.to raise_error(RuntimeError)
          end

          Given(:configured_repository_connection) { double(find_or_initialize: true) }
          When { configuration.repository_connection = configured_repository_connection }
          Then { configuration.repository_connection == configured_repository_connection }
        end

      end
    end
  end
end

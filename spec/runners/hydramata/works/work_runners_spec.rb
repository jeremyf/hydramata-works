require 'spec_fast_helper'
require 'hydramata/works/work_runners'
require 'hydramata/works/stub_callback'

module Hydramata
  module Works
    module WorkRunners
      describe New do

        Given(:callback) { StubCallback.new }
        Given(:callback_config) { callback.configure(:success, :created_with_invalid_data) }
        Given(:context) { double('Context', services: services) }
        Given(:returning_object) { double('Returning Object') }

        describe AvailableType do
          Given(:runner) { described_class.new(context, &callback_config) }
          Given(:returning_object) { double('Returning Object') }
          Given(:services) { double('Services', available_work_types: returning_object)}
          When(:result) { runner.run }
          Then { expect(result).to eq([returning_object]) }
          And { expect(callback.invoked).to eq([:success, returning_object]) }
          And { expect(services).to have_received(:available_work_types) }
        end

        describe New do
          Given(:work_type) { 'article' }
          Given(:attributes) { {} }
          Given(:runner) { described_class.new(context, &callback_config) }
          Given(:services) { double('Services', new_work_for: returning_object)}
          When(:result) { runner.run(work_type, attributes) }
          Then { expect(result).to eq([returning_object]) }
          And { expect(callback.invoked).to eq([:success, returning_object]) }
          And { expect(services).to have_received(:new_work_for).with(work_type, attributes) }
        end

        describe Create do
          Given(:work_type) { 'article' }
          Given(:attributes) { {} }
          Given(:runner) { described_class.new(context, &callback_config) }
          Given(:services) { double('Services', new_work_for: returning_object, save_work: save_work_returned_value)}
          When(:result) { runner.run(work_type, attributes) }
          context 'good data' do
            Given(:save_work_returned_value) { 'valid' }
            Then { expect(result).to eq([returning_object]) }
            And { expect(callback.invoked).to eq([:success, returning_object]) }
            And { expect(services).to have_received(:new_work_for).with(work_type, attributes) }
            And { expect(services).to have_received(:save_work).with(returning_object) }
          end
          context 'saved but invalid' do
            Given(:save_work_returned_value) { 'invalid' }
            Then { expect(result).to eq([returning_object]) }
            And { expect(callback.invoked).to eq([:created_with_invalid_data, returning_object]) }
            And { expect(services).to have_received(:new_work_for).with(work_type, attributes) }
            And { expect(services).to have_received(:save_work).with(returning_object) }
          end
          context 'bad data' do
            Given(:save_work_returned_value) { false }
            Then { expect(result).to eq([returning_object]) }
            And { expect(callback.invoked).to eq([:failure, returning_object]) }
            And { expect(services).to have_received(:new_work_for).with(work_type, attributes) }
            And { expect(services).to have_received(:save_work).with(returning_object) }
          end
        end

        describe Show do
          Given(:identifier) { '123' }
          Given(:runner) { described_class.new(context, &callback_config) }
          Given(:services) { double('Services', find_work: returning_object)}
          When(:result) { runner.run(identifier) }
          Then { expect(result).to eq([returning_object]) }
          And { expect(callback.invoked).to eq([:success, returning_object]) }
          And { expect(services).to have_received(:find_work).with(identifier) }
        end

        describe Edit do
          Given(:identifier) { '123' }
          Given(:runner) { described_class.new(context, &callback_config) }
          Given(:services) { double('Services', edit_work: returning_object)}
          Given(:attributes) { { key: :value } }
          When(:result) { runner.run(identifier, attributes) }
          Then { expect(result).to eq([returning_object]) }
          And { expect(callback.invoked).to eq([:success, returning_object]) }
          And { expect(services).to have_received(:edit_work).with(identifier, attributes) }
        end

      end
    end
  end
end

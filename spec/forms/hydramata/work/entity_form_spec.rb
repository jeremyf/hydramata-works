require 'spec_fast_helper'
require 'hydramata/work/entity_form'
require 'hydramata/work/linters'
require 'hydramata/work/entity'

module Hydramata
  module Work
    describe EntityForm do
      let(:identity) { nil }
      let(:validation_service) { double(call: true) }
      let(:entity) do
        Entity.new(identity: identity) do |entity|
          entity.properties << { predicate: :first_name, value: 'Jeremy' }
        end
      end
      subject { described_class.new(entity, validation_service: validation_service) }

      it_behaves_like 'ActiveModel'

      context 'valid?' do
        context 'when errors are not set' do
          let(:validation_service) { double(call: true) }
          it 'should be true (eg valid)' do
            expect(subject.valid?).to be_truthy
            expect(validation_service).to have_received(:call)
          end
        end
        context 'when errors are encountered' do
          let(:validation_service) { ->(entity) { entity.errors.add(:base, 'Found some errors!') } }
          it 'should be false (eg not valid)' do
            expect(subject.valid?).to be_falsey
          end
        end
      end

      it 'has a meaningful inspect' do
        expect(subject.inspect).to include("EntityForm")
        expect(subject.inspect).to include(entity.inspect)
      end

      context 'entity\'s properties' do
        it 'should respond to a given predicate' do
          expect(subject).to respond_to(:first_name)
        end

        it 'should expose the predicate name as a method' do
          expect(subject.first_name).to eq(['Jeremy'])
        end
      end

      context 'with collaborating entity without an identity' do
        let(:identity) { '' }
        it 'is not #persisted?' do
          expect(subject.persisted?).to be_falsey
        end

        it 'has a nil #to_param' do
          expect(subject.to_param).to be_nil
        end

        it 'has a nil #to_key' do
          expect(subject.to_key).to be_nil
        end
      end

      context 'with collaborating entity with an identity' do
        let(:identity) { '1234' }
        it 'is #persisted?' do
          expect(subject.persisted?).to be_truthy
        end

        it 'uses the entity#identity to derive #to_param' do
          expect(subject.to_param).to eq(identity)
        end

        it 'uses the entity#identity to derive #to_key' do
          expect(subject.to_key).to eq([identity])
        end

      end
    end
  end
end

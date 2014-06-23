require 'spec_fast_helper'
require 'hydramata/work/entity_form'
require 'hydramata/work/linters'
require 'hydramata/work/entity'

module Hydramata
  module Work
    describe EntityForm do
      let(:identity) { nil }
      let(:entity) do
        Entity.new(identity: identity) do |entity|
          entity.properties << { predicate: :first_name, value: 'Jeremy' }
        end
      end
      subject { described_class.new(entity) }

      it_behaves_like 'ActiveModel'

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

require 'spec_fast_helper'
require 'hydramata/work/entity'
require 'hydramata/work/linters/implement_entity_interface_matcher'

module Hydramata
  module Work
    describe Entity do
      subject { described_class.new }
      it { should implement_entity_interface }

      let(:predicate) { :title }
      let(:value) { 'Hello' }
      let(:property) { Property.new(predicate: predicate, value: value) }

      context '#properties' do
        it 'can be appended' do
          expect { subject.properties << property }.
            to change { subject.properties.count }.
            by(1)
        end
      end

      context '#property' do
        it 'returns matching predicates' do
          subject.properties << property
          expect(subject.properties[predicate]).to eq(property)
        end
      end
    end
  end
end

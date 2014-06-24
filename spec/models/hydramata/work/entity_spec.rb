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


      context '#to_presenter' do
        let(:presenter_builder) { double('Presenter Builder', call: :built) }
        subject { described_class.new(presenter_builder: presenter_builder) }
        it 'should call the presenter_builder' do
          expect(subject.to_presenter).to eq(:built)
          expect(presenter_builder).to have_received(:call).with(subject)
        end
      end

      context '#has_property?' do
        it 'changes from false to true when the property is added' do
          expect { subject.properties << property }.
            to change { subject.has_property?(predicate) }.
            from(false).
            to(true)
        end
      end

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

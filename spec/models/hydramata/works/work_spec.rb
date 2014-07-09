require 'spec_fast_helper'
require 'hydramata/works/work'
require 'hydramata/works/property'
require 'hydramata/works/linters/implement_work_interface_matcher'
require 'hydramata/works/linters/implement_property_interface_matcher'

module Hydramata
  module Works
    describe Work do
      subject { described_class.new }
      it { should implement_work_interface }

      let(:predicate) { :title }
      let(:value) { 'Hello' }
      let(:property) { Property.new(predicate: predicate, value: value) }


      context '#to_presenter' do
        let(:presenter_builder) { double('Presenter Builder', call: :built) }
        subject { described_class.new(presenter_builder: presenter_builder) }
        it 'calls the presenter_builder' do
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

        it 'returns a property with empty values if the predicate was not assigned' do
          property_with_undefined_predicate = subject.properties[:obviously_missing]
          expect(property_with_undefined_predicate).to implement_property_interface
          expect(property_with_undefined_predicate.values).to eq([])
        end
      end
    end
  end
end

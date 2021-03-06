require 'spec_fast_helper'
require 'hydramata/works/property'
require 'hydramata/works/predicate'

module Hydramata
  module Works
    describe Property do
      let(:predicate) { Predicate.new(identity: 'Predicate') }
      let(:value) { double('Value') }
      subject { described_class.new(predicate: predicate) }

      it { should respond_to :values }
      it { should respond_to :name }

      it 'delegates #each to #values' do
        subject << value
        expect { |b| subject.each(&b) }.to yield_with_args(value)
      end

      it 'delegates #required? to :predicate' do
        expect(subject.required?).to eq(predicate.required?)
      end

      it 'can append to values' do
        expect { subject.append_values value }.
          to change { subject.values }.
          from([]).
          to([value])
      end

      it 'skips appending values that are not present' do
        expect { subject << '' }.
          to_not change { subject.values }
      end

      it 'can replace values' do
        subject << value
        expect { subject.replace_values('New') }.
          to change { subject.values }.
          from([value]).
          to(['New'])
      end

      it 'has a #to_translation_key_fragment' do
        expect(subject.to_translation_key_fragment).to eq(subject.predicate.to_translation_key_fragment)
      end

      context 'case equality' do
        it 'delegates to the compared object' do
          object = double('Double')
          expect(object).
            to receive(:instance_of?).
            with(Property).
            and_return(true)
          expect(Property === object).to eq(true)
        end
      end

      context 'equality' do
        it 'is not equal if the predicates are different' do
          property = described_class.new(predicate: :hello)
          other = described_class.new(predicate: :goodbye)
          expect(property == other).to eq(false)
        end

        it 'is equal if the predicates and values are the same' do
          property = described_class.new(predicate: :hello, values: [123])
          other = described_class.new(predicate: :hello, values: [123])
          expect(property == other).to eq(true)
        end

        it 'is not equal if the predicates are the same but values are the different' do
          property = described_class.new(predicate: :hello, values: [123])
          other = described_class.new(predicate: :hello, values: [123, 345])
          expect(property == other).to eq(false)
        end

        it 'is not equal if the predicates are different but the values are the same' do
          property = described_class.new(predicate: :goodbye, values: [123])
          other = described_class.new(predicate: :hello, values: [123])
          expect(property == other).to eq(false)
        end

        it 'is not equal if of different classes' do
          property = described_class.new(predicate: :goodbye, values: [123])
          other = Struct.new(:predicate, :values).new(:goodbye, [123])
          expect(property == other).to eq(false)
        end
      end
    end
  end
end

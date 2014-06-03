require 'fast_helper'
require 'hydramata/work/property'

module Hydramata
  module Work
    describe Property do
      let(:predicate) { double('Predicate') }
      let(:value) { double('Value') }
      subject { described_class.new(predicate: predicate) }

      it { should respond_to :values }

      it 'should delegate #each to #values' do
        subject << value
        expect{|b| subject.each(&b) }.to yield_with_args(value)
      end

      it 'can append to values' do
        expect { subject << value }
        .to change { subject.values }
        .from([])
        .to([value])
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

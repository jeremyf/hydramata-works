require 'spec_fast_helper'
require 'hydramata/work/property_set'

module Hydramata
  module Work
    describe PropertySet do
      subject { PropertySet.new }
      let(:property) { Property.new(predicate: :title, value: 'value one') }

      context 'predicate order' do
        it 'the first predicate pushed will return as the first' do
          subject << (first = Property.new(predicate: :one, value: 1))
          subject << (second = Property.new(predicate: :two, value: 2))
          subject << (third = Property.new(predicate: :three, value: 3))

          # Note: I am pushing a Property with the same predicate as the first
          # object pushed. This will modify
          subject << Property.new(predicate: :one, value: 4)

          expect { |b| subject.each(&b) }.to yield_successive_args(first, second, third)
        end
      end

      it 'exposes #properties' do
        subject << property
        expect(subject.properties).to eq([property])
      end

      it 'allows properties to be pushed onto it' do
        expect { subject << property }.
          to change { subject.count }.
          by(1)
      end

      it 'amends an existing property if a common predicate is found' do
        property = Property.new(predicate: :title, value: 'value one')
        property_with_same_predicate = Property.new(predicate: :title, value: 'another')
        subject << property
        expect do
          expect { subject << property_with_same_predicate }.
            to_not change { subject.count }
        end.to change { property.values }.
          from(['value one']).
          to(['value one', 'another'])
      end

      context 'data retrieval methods' do
        before { subject << property }

        context '#predicates' do
          it 'should be the predicate names' do
            expect(subject.predicates).to eq [property.predicate.to_s]
          end
        end

        context '#fetch' do
          it 'should raise an error if the predicate is not found' do
            expect { subject.fetch(:missing) }.to raise_error(KeyError)
          end

          it 'should return the values if the predicate exists' do
            expect(subject.fetch(property.predicate)).to eq(property)
          end
        end

        context '#[]' do
          it 'should return nil if the predicate is not found' do
            expect(subject[:missing]).to eq(Property.new(predicate: :missing))
          end

          it 'should return the values if the predicate exists' do
            expect(subject[property.predicate]).to eq(property)
          end
        end

        context '#each' do
          it 'should yield the predicate and normalized values' do
            expect { |b| subject.each(&b) }.to yield_with_args(property)
          end
        end

        context '#==' do
          it 'should return true if underlying properties are identical' do
            property_set = described_class.new
            other = described_class.new

            expect(property_set == other).to be_truthy
          end

          it 'should return false if different classes' do
            property_set = described_class.new
            other = 'abc'

            expect(property_set == other).to be_falsey
          end

          it 'should return false if underlyng properties are different' do
            property_set = described_class.new
            other = described_class.new
            property_set << property

            expect(property_set == other).to be_falsey
          end

          it 'should return true if empty property set and hash are compared' do
            property_set = described_class.new
            other = {}

            expect(property_set == other).to be_truthy
          end
        end

        context '#subset' do
          let(:a_second_property) { { predicate: :another_predicate, value: 'another value' } }
          it 'should return a property set that only has the specified keys' do
            subject << a_second_property
            subset = described_class.new
            subset << property
            expect(subject.subset(property.predicate)).to eq(subset)
          end
        end
      end
    end
  end
end

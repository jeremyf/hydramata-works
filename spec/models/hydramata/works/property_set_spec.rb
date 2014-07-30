require 'spec_fast_helper'
require 'hydramata/works/property_set'

module Hydramata
  module Works
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


      it 'raises exception if you specify an invalid push strategy' do
        expect { PropertySet.new(property_value_strategy: :invalid) }.to raise_error
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

      context 'push strategy' do
        subject { PropertySet.new(property_value_strategy: property_value_strategy) }

        it 'defaults to :append_values' do
          expect(described_class.new.property_value_strategy).to eq(:append_values)
        end

        context ':append_values' do
          let(:property_value_strategy) { :append_values }
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
        end

        context ':replace_values' do
          let(:property_value_strategy) { :replace_values }
          it "replaces an existing property's values" do
            property = Property.new(predicate: :title, value: 'value one')
            property_with_same_predicate = Property.new(predicate: :title, value: 'another')
            subject << property
            expect do
              expect { subject << property_with_same_predicate }.
                to_not change { subject.count }
            end.to change { property.values }.
              from(['value one']).
              to(['another'])
          end
        end
      end

      context 'data retrieval methods' do
        before { subject << property }

        context '#predicates' do
          it 'is a collection of predicate names' do
            expect(subject.predicates).to eq [property.predicate.to_s]
          end
        end

        context '#fetch' do
          it 'raises an error if the predicate is not found' do
            expect { subject.fetch(:missing) }.to raise_error(KeyError)
          end

          it 'returns the values if the predicate exists' do
            expect(subject.fetch(property.predicate)).to eq(property)
          end
        end

        context '#key?' do
          it 'returns false if predicate does not exist' do
            expect(subject.key?(:missing)).to be_falsey
          end

          it 'returns the values if the predicate exists' do
            expect(subject.key?(property.predicate)).to be_truthy
          end
        end

        context '#[]' do
          it 'returns nil if the predicate is not found' do
            expect(subject[:missing]).to eq(Property.new(predicate: :missing))
          end

          it 'returns the values if the predicate exists' do
            expect(subject[property.predicate]).to eq(property)
          end
        end

        context '#each' do
          it 'yields the predicate and normalized values' do
            expect { |b| subject.each(&b) }.to yield_with_args(property)
          end
        end

        context '#==' do
          it 'returns true if underlying properties are identical' do
            property_set = described_class.new
            other = described_class.new

            expect(property_set == other).to be_truthy
          end

          it 'returns false if different classes' do
            property_set = described_class.new
            other = 'abc'

            expect(property_set == other).to be_falsey
          end

          it 'returns false if underlyng properties are different' do
            property_set = described_class.new
            other = described_class.new
            property_set << property

            expect(property_set == other).to be_falsey
          end

          it 'returns true if empty property set and hash are compared' do
            property_set = described_class.new
            other = {}

            expect(property_set == other).to be_truthy
          end
        end

        context '#subset' do
          let(:a_second_property) { { predicate: :another_predicate, value: 'another value' } }
          it 'returns a property set that only has the specified keys' do
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

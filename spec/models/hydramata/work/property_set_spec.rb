require 'fast_helper'
require 'hydramata/work/property_set'

module Hydramata
  module Work
    describe PropertySet do
      subject { PropertySet.new }
      let(:property) { Property.new(predicate: :title, value: 'value one') }


      it 'allows properties to be pushed onto it' do
        expect { subject << property }
        .to change { subject.count }
        .by(1)
      end

      it 'amends an existing property if a common predicate is found' do
        subject << { predicate: :title, value: 'value one' }
        expect { subject << { predicate: :title, value: 'value one' } }
        .to_not change { subject.count }
      end

      context 'data retrieval methods' do
        before { subject << property }

        its(:predicates) { should eq [property.predicate.to_s] }

        context '#fetch' do
          it 'should raise an error if the predicate is not found' do
            expect { subject.fetch(:missing) }
            .to raise_error(KeyError)
          end

          it 'should return the values if the predicate exists' do
            expect(subject.fetch(property.predicate))
            .to eq(property)
          end
        end

        context '#[]' do
          it 'should return nil if the predicate is not found' do
            expect(subject[:missing]).to eq(Property.new(predicate: :missing))
          end
          it 'should return the values if the predicate exists' do
            expect(subject[property.predicate])
            .to eq(property)
          end
        end

        context '#each' do
          it 'should yield the predicate and normalized values' do
            expect{|b| subject.each(&b) }.to yield_with_args(property)
          end
        end

        context '#==' do
          it 'should return true if underlying properties are identical' do
            property_set = described_class.new
            other = described_class.new

            expect(property_set == other).to be_true
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

require 'spec_fast_helper'
require 'hydramata/works/conversions/property'

module Hydramata
  module Works
    describe Conversions do
      include Conversions

      context '#Property' do

        context 'with 0 args' do
          it 'raises an error' do
            expect { Property() }.to raise_error
          end
        end

        context 'with 1 arg' do
          it 'converts a Predicate to a Property' do
            predicate = Predicate.new(identity: 'id')
            expect(Property(predicate)).to be_an_instance_of(Property)
          end

          it 'attempts to convert something odd to a Property via a Predicate conversion' do
            object_to_convert = double
            expect(self).
              to receive(:Predicate).
              with(object_to_convert).
              and_return(Predicate.new)
            expect(Property(object_to_convert)).to be_an_instance_of(Property)
          end

          it 'preserves a Property' do
            property = Property.new(predicate: 'a predicate')
            expect(Property(property).object_id).to eq(property.object_id)
          end

          it 'converts a Hash to a property' do
            expect(Property(predicate: 'a predicate')).to be_an_instance_of(Property)
          end

          it 'converts a Hash with values' do
            expect(Property(predicate: 'a predicate', values: [1,2,3]).values).to eq([1,2,3])
          end
        end

        context 'with 2 args' do
          it 'converts two arguements to a Property' do
            expect(Property('a predicate', 'a value')).to be_an_instance_of(Property)
          end

          it 'handles two arguements where last arguement is an array' do
            expect(Property('a predicate', ['a value']).values).to eq([['a value']])
          end

          it 'preserves the property but append the values' do
            property = Property.new(predicate: 'a predicate')
            expect {
              Property(property, 'hello')
            }.
              to change { property.values }.
              from([]).
              to(['hello'])
          end
        end
      end
    end
  end
end

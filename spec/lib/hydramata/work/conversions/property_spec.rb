require 'spec_slow_helper'
require 'hydramata/work/conversions/property'

module Hydramata
  module Work
    describe Conversions do
      include Conversions

      context '#Property' do

        context 'with 0 args' do
          it 'should raise an error' do
            expect { Property() }.to raise_error
          end
        end

        context 'with 1 arg' do
          it 'should convert a Predicate to a Property' do
            predicate = Predicate.new(identity: 'id')
            expect(Property(predicate)).to be_an_instance_of(Property)
          end

          it 'should attempt to convert something odd to a Property via a Predicate conversion' do
            object_to_convert = double
            expect(self).
              to receive(:Predicate).
              with(object_to_convert).
              and_return(Predicate.new)
            expect(Property(object_to_convert)).to be_an_instance_of(Property)
          end

          it 'should preserve a Property' do
            property = Property.new(predicate: 'a predicate')
            expect(Property(property).object_id).to eq(property.object_id)
          end

          it 'should convert a Hash to a property' do
            expect(Property(predicate: 'a predicate')).to be_an_instance_of(Property)
          end

          it 'should convert a Hash with values' do
            expect(Property(predicate: 'a predicate', values: [1,2,3]).values).to eq([1,2,3])
          end
        end

        context 'with 2 args' do
          it 'should convert two arguements to a Property' do
            expect(Property('a predicate', 'a value')).to be_an_instance_of(Property)
          end

          it 'should gracefully handle two arguements where last arguement is an array' do
            expect(Property('a predicate', ['a value']).values).to eq([['a value']])
          end

          it 'should preserve the property but append the values' do
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

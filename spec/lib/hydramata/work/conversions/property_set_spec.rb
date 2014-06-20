require 'spec_fast_helper'
require 'hydramata/work/conversions/property_set'
require 'hydramata/work/conversions/predicate_set'
require 'hydramata/work/linters/implement_property_set_interface_matcher'

module Hydramata
  module Work
    describe Conversions do
      include Conversions

      context '#PropertySet' do
        it 'should convert an object that implements #to_property_set' do
          object = double('Object', to_property_set: PropertySet.new )
          expect(PropertySet(object)).to implement_property_set_interface
        end

        it 'should raise an error object is unexpected' do
          expect { PropertySet([]) }.to raise_error
        end

        it 'should convert a PredicateSet to a PropertySet' do
          object = PredicateSet.new(identity: 'hello')
          expect(PropertySet(object)).to implement_property_set_interface
        end

        it 'should preserive a PropertySet as that PropertySet' do
          object = PropertySet.new(identity: 'hello')
          expect(PropertySet(object).object_id).to eq(object.object_id)
        end

        it 'should attempt to convert the input to a PredicateSet then a PropertySet' do
          object_to_convert = { identity: 'hello' }
          expect(self).
            to receive(:PredicateSet).
            with(object_to_convert).
            and_call_original
          expect(PropertySet(object_to_convert)).to implement_property_set_interface
        end
      end
    end
  end
end

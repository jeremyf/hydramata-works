require 'spec_fast_helper'
require 'hydramata/works/conversions/predicate_set'
require 'hydramata/works/linters/implement_predicate_set_interface_matcher'

module Hydramata
  module Works
    describe Conversions do
      include Conversions

      context '#PredicateSet' do
        it 'should convert a "well-formed" Hash to a PredicateSet object' do
          expect(PredicateSet(identity: 'hello', work_type: 'Work Type')).to implement_predicate_set_interface
        end

        it 'should raise an error if the Hash is not "well-formed"' do
          expect { PredicateSet(other: 'hello') }.to raise_error
        end

        it 'should raise an error when input is unexpected' do
          expect { PredicateSet(double) }.to raise_error
        end

        it 'should raise an error when Array is empty' do
          expect { PredicateSet([]) }.to raise_error
        end

        it 'should handle an Array of 2 elements' do
          expect(PredicateSet([:fieldset, [:predicate1, :predicate2]])).to implement_predicate_set_interface
        end

        it 'should handle an Array of 3 elements' do
          expect(PredicateSet([:fieldset, :predicate1, :predicate2])).to implement_predicate_set_interface
        end

        it 'should handle an Array of 1 element' do
          expect(PredicateSet([:fieldset])).to implement_predicate_set_interface
        end

        it 'should handle a String' do
          expect(PredicateSet('An Identity')).to implement_predicate_set_interface
        end

        it 'should use #to_predicate_set for conversion if input responds to #to_predicate_set' do
          object = double(to_predicate_set: PredicateSet.new(identity: 'hello'))
          expect(PredicateSet(object)).to implement_predicate_set_interface
        end
      end
    end
  end
end

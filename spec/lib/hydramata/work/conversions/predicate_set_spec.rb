require 'feature_helper'
require 'hydramata/work/conversions/predicate_set'
require 'hydramata/work/linters/implement_predicate_set_interface_matcher'

module Hydramata
  module Work
    describe Conversions do
      include Conversions

      context '#PredicateSet' do
        it 'should convert a "well-formed" Hash to a PredicateSet object' do
          expect(PredicateSet(identity: 'hello', work_type: 'Work Type')).to implement_predicate_set_interface
        end

        it 'should raise an error if the Hash is not "well-formed"' do
          expect { PredicateSet(other: 'hello') }.to raise_error
        end

        it 'should raise an error when Array is of wrong size' do
          expect { PredicateSet([]) }.to raise_error
        end

        it 'should raise an error when input is unexpected' do
          expect { PredicateSet(double) }.to raise_error
        end

        it 'should handle a "well formed" Array' do
          expect(PredicateSet([:fieldset, [:predicate1, :predicate2]])).to implement_predicate_set_interface
        end

        it 'should converate a "stored predicate" to a predicate' do
          storage = PredicateSets::Storage.new(identity: 'hello', work_type: WorkTypes::Storage.new(identity: 'Work Type'))
          expect(PredicateSet(storage)).to implement_predicate_set_interface
        end
      end
    end
  end
end

require 'feature_helper'
require 'hydramata/work/conversions/predicate'
require 'hydramata/work/linters/implement_predicate_interface_matcher'

module Hydramata
  module Work
    describe Conversions do
      include Conversions

      context '#Predicate' do
        it 'should convert a String to a Predicate object' do
          expect(Predicate('hello')).to implement_predicate_interface
        end

        it 'should convert a Symbol to a Predicate object' do
          expect(Predicate(:hello)).to implement_predicate_interface
        end

        it 'should return the same predicate if a Predicate is given' do
          predicate = Predicate(:hello)
          expect(Predicate(predicate).object_id).to eq(predicate.object_id)
        end

        it 'should convert a "well-formed" Hash to a Predicate object' do
          expect(Predicate(identity: 'hello')).to implement_predicate_interface
        end

        it 'should raise an error if the Hash is not "well-formed"' do
          expect { Predicate(other: 'hello') }.to raise_error
        end

        it 'should raise an error object is unexpected' do
          expect { Predicate([]) }.to raise_error
        end

        it 'should converate a "stored predicate" to a predicate' do
          expect(Predicate(Predicates::Storage.new(identity: 'hello'))).to implement_predicate_interface
        end
      end
    end
  end
end

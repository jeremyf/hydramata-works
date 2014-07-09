require 'spec_fast_helper'
require 'hydramata/works/conversions/predicate'
require 'hydramata/works/linters/implement_predicate_interface_matcher'

module Hydramata
  module Works
    describe Conversions do
      include Conversions

      context '#Predicate' do
        it 'converts a String to a Predicate object' do
          expect(Predicate('hello')).to implement_predicate_interface
        end

        it 'converts a Symbol to a Predicate object' do
          expect(Predicate(:hello)).to implement_predicate_interface
        end

        it 'returns the same predicate if a Predicate is given' do
          predicate = Predicate(:hello)
          expect(Predicate(predicate).object_id).to eq(predicate.object_id)
        end

        it 'converts a "well-formed" Hash to a Predicate object' do
          expect(Predicate(identity: 'hello')).to implement_predicate_interface
        end

        it 'raises an error if the Hash is not "well-formed"' do
          expect { Predicate(other: 'hello') }.to raise_error
        end

        it 'raises an error object is unexpected' do
          expect { Predicate([]) }.to raise_error
        end

        it 'converates an object that responds to #to_predicate to a predicate' do
          object = double(to_predicate: Predicate.new)
          expect(Predicate(object)).to implement_predicate_interface
        end
      end
    end
  end
end

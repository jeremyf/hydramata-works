require 'spec_fast_helper'
require 'hydramata/works/conversions/value'
require 'hydramata/works/linters/implement_value_interface_matcher'

module Hydramata
  module Works
    describe Conversions do
      include Conversions

      context '#Value' do
        it 'converts a Hash to a Value object' do
          expect(Value(value: 'hello')).to implement_value_interface
        end

        it 'converts an object that implements #to_value' do
          object = double(to_value: Value.new(value: 'Value'))
          expect(Value(object)).to eq(object.to_value)
        end

        it 'converts a String to a Value object' do
          expect(Value('hello')).to implement_value_interface
        end

        it 'returns the same Value if a Value is given' do
          value = Value('hello')
          expect(Value(value).object_id).to eq(value.object_id)
        end

        it 'raises an error object is unexpected' do
          expect { Value([]) }.to raise_error
        end

      end
    end
  end
end

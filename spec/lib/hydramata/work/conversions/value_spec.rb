require 'spec_fast_helper'
require 'hydramata/work/conversions/value'
require 'hydramata/work/linters/implement_value_interface_matcher'

module Hydramata
  module Work
    describe Conversions do
      include Conversions

      context '#Value' do
        it 'should convert a Hash to a Value object' do
          expect(Value(value: 'hello')).to implement_value_interface
        end

        it 'should convert an object that implements #to_value' do
          object = double(to_value: Value.new(value: 'Value'))
          expect(Value(object)).to eq(object.to_value)
        end

        it 'should convert a String to a Value object' do
          expect(Value('hello')).to implement_value_interface
        end

        it 'should return the same Value if a Value is given' do
          value = Value('hello')
          expect(Value(value).object_id).to eq(value.object_id)
        end

        it 'should raise an error object is unexpected' do
          expect { Value([]) }.to raise_error
        end

      end
    end
  end
end

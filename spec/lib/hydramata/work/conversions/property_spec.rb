require 'feature_helper'
require 'hydramata/work/conversions/property'

module Hydramata
  module Work
    describe Conversions do
      include Conversions

      context '#Property' do
        it 'should convert a Hash to a property' do
          expect(Property(predicate: 'a predicate')).to be_an_instance_of(Property)
        end

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
      end
    end
  end
end

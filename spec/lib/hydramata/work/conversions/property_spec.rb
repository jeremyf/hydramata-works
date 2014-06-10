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

        it 'should preserve a Property' do
          property = Property.new(predicate: 'a predicate')
          expect(Property(property).object_id).to eq(property.object_id)
        end
      end
    end
  end
end

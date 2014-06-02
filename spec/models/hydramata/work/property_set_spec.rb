require 'fast_helper'
require 'hydramata/work/property_set'

module Hydramata
  module Work
    describe PropertySet do
      subject { PropertySet.new }

      it 'allows properties to be pushed onto it' do
        expect { subject << { predicate: :title, value: 'value' } }
        .to change { subject.count }
        .by(1)
      end

      it 'amends an existing property if a common predicate is found' do
        subject << { predicate: :title, value: 'value one' }
        expect { subject << { predicate: :title, value: 'value one' } }
        .to_not change { subject.count }
      end

    end
  end
end

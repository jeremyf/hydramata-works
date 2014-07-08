require 'spec_fast_helper'
require 'hydramata/works/predicates'
require 'hydramata/works/linters/implement_predicate_interface_matcher'


module Hydramata
  module Works
    describe Predicates do

      context '.find' do
        it 'uses the identity to construct the appropriate predicate' do
          expect(described_class.find('name', { something: 'george' })).to implement_predicate_interface
        end
      end

    end
  end
end

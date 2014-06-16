require 'fast_helper'
require 'hydramata/work/predicate_set'
require 'hydramata/work/linters/implement_predicate_set_interface_matcher'

module Hydramata
  module Work
    describe PredicateSet do
      subject { described_class.new(identity: 'My Identity') }
      it { should implement_predicate_set_interface }

      it 'should initialize via attributes' do
        expect(subject.identity).to eq('My Identity')
      end

    end
  end
end

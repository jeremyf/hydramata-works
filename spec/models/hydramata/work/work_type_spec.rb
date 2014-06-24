# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'spec_fast_helper'
require 'hydramata/work/work_type'
require 'hydramata/work/linters/implement_work_type_interface_matcher'
require 'hydramata/work/linters/implement_data_definition_interface_matcher'

module Hydramata
  module Work
    describe WorkType do
      subject { described_class.new(identity: 'My Identity') }
      it { should implement_work_type_interface }
      it { should implement_data_definition_interface }

      context '#predicate_sets=' do
        it 'handles predicate set conversion' do
          subject = described_class.new(identity: 'My Identity', predicate_sets: ['one predicate', 'two predicate'])
          expect(subject.predicate_sets).to eq([PredicateSet.new(identity: 'one predicate'), PredicateSet.new(identity: 'two predicate')])
        end
      end

      it 'should have #fieldsets that is an alias of #predicate_sets' do
        subject = described_class.new(identity: 'My Identity', predicate_sets: ['one predicate', 'two predicate'])
        expect(subject.fieldsets).to eq(subject.predicate_sets)
      end
    end
  end
end

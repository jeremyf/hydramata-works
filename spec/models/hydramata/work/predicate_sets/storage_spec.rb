# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'active_record_spec_helper'
require 'hydramata/work/work_type'
require 'hydramata/work/predicate_sets/storage'
require 'hydramata/work/linters/implement_predicate_set_interface_matcher'

module Hydramata
  module Work
    module PredicateSets

      describe Storage do
        subject { described_class.new }
        it { should implement_predicate_set_interface }

        let(:identity) { 'a predicate' }
        let(:work_type) { WorkTypes::Storage.create(identity: 'a_work_type') }
        subject do
          described_class.create(
            work_type: work_type,
            identity: identity,
            presentation_sequence: 1,
            name_for_application_usage: 'predicate_set_name'
          )
        end

        it 'belongs to a work_type' do
          expect(subject.work_type).to eq(work_type)
        end

      end
    end
  end
end

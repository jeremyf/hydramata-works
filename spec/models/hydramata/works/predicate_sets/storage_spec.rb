# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'spec_active_record_helper'
require 'hydramata/works/work_type'
require 'hydramata/works/predicate_sets/storage'
require 'hydramata/works/linters/implement_predicate_set_interface_matcher'

module Hydramata
  module Works
    module PredicateSets

      describe Storage do
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

        it 'belongs to a work type' do
          expect(subject.work_type).to eq(work_type)
        end

        it 'has many predicates' do
          expect(subject.predicates).to eq([])
        end

        it 'has many predicate_presentation_sequences' do
          expect(subject.predicate_presentation_sequences).to eq([])
        end

        it 'belongs to a work_type' do
          expect(subject.work_type).to eq(work_type)
        end

        it 'has #to_predicate_set' do
          expect(described_class.new.to_predicate_set).to implement_predicate_set_interface
        end

        context 'with feature seed data' do
          before do
            load File.expand_path('../../../../../support/feature_seeds.rb', __FILE__)
          end

          let(:work_type) { WorkTypes::Storage.where(identity: 'article').first! }
          let(:predicate_set) { described_class.where(work_type: work_type, identity: 'required').first! }

          it 'has properly sorted predicates' do
            expect(predicate_set.predicates.map(&:to_s)).to eq(['dc_title', 'dc_description'])
          end
        end

      end
    end
  end
end

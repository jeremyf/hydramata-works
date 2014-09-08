require 'spec_slow_helper'
require 'hydramata/works/persister'
require 'hydramata/works/works/database_storage'

module Hydramata
  module Works

    describe 'A work persisted' do

      context 'to a database' do
        it 'increments the database record for a given work' do
          expect { Persister.call(work: work) }.
            to change { Works::DatabaseStorage.count }.
            by(1)
        end
      end

      context 'and loaded a database' do

        before do
          persister.call
        end
        let(:persister) { Persister.new(work: work) }
        let(:stored_work) { Works::DatabaseStorage.where(pid: persister.pid).first }

        it 'is equal to the original work' do
          reified_work = stored_work.to_work
          expect(reified_work.work_type).to eq(work.work_type)
          expect(reified_work.properties).to eq(work.properties)
          expect(reified_work.identity).to eq(work.identity)
          # @TODO make this work --> expect(reified_work).to eq(work)
        end
      end

      let(:work) do
        Work.new do |work|
          work.work_type = work_type
          work.properties << { predicate: predicate_title, value: 'Hello' }
          work.properties << { predicate: predicate_title, value: 'World' }
          work.properties << { predicate: predicate_title, value: 'Bang!' }
          work.properties << { predicate: predicate_abstract, value: 'Long Text' }
          work.properties << { predicate: predicate_abstract, value: 'Longer Text' }
          work.properties << { predicate: predicate_keyword, value: 'Programming' }
        end
      end

      let(:predicate_title) { Predicates::Storage.new(identity: 'http://purl.org/dc/terms/dc_title', name_for_application_usage: 'title') }
      let(:predicate_abstract) { Predicates::Storage.new(identity: 'http://purl.org/dc/terms/dc_abstract', name_for_application_usage: 'abstract') }
      let(:predicate_keyword) { Predicates::Storage.new(identity: 'http://purl.org/dc/terms/dc_keyword', name_for_application_usage: 'keyword') }
      let(:work_type) { WorkTypes::Storage.new(identity: 'Special Work Type') }
      let(:predicate_set_required) { PredicateSets::Storage.new(identity: 'required', work_type: work_type, presentation_sequence: 1) }
      let(:predicate_set_optional) { PredicateSets::Storage.new(identity: 'optional', work_type: work_type, presentation_sequence: 2) }

      before do
        predicate_title.save!
        predicate_abstract.save!
        predicate_keyword.save!
        work_type.save!
        predicate_set_optional.save!
        predicate_set_required.save!
        PredicatePresentationSequences::Storage.create!(predicate: predicate_title, predicate_set: predicate_set_required, presentation_sequence: 1)
        PredicatePresentationSequences::Storage.create!(predicate: predicate_abstract, predicate_set: predicate_set_optional, presentation_sequence: 1)
        PredicatePresentationSequences::Storage.create!(predicate: predicate_keyword, predicate_set: predicate_set_optional, presentation_sequence: 2)
      end
    end
  end
end

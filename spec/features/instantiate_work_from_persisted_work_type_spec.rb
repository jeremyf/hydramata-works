require 'spec_active_record_helper'
require 'hydramata/works/work_types/storage'
require 'hydramata/works/predicate_sets/storage'
require 'hydramata/works/predicates/storage'
require 'hydramata/works/property'
require 'hydramata/works/work'

module Hydramata
  module Works
    describe 'Instantiating an work from a persisted work type' do
      before do
        @article = Hydramata::Works::WorkTypes::Storage.create!(identity: 'article', name_for_application_usage: 'article')
        @predicate_set = Hydramata::Works::PredicateSets::Storage.create!(identity: 'required', work_type: @article, presentation_sequence: 1, name_for_application_usage: 'required')
        @title_predicate = Hydramata::Works::Predicates::Storage.create!(identity: "http://purl.org/dc/terms/dc_title", name_for_application_usage: 'title')
        @predicate_set.predicate_presentation_sequences.create!(presentation_sequence: 1, predicate: @title_predicate)
        @alternate_predicate = Hydramata::Works::Predicates::Storage.create!(identity: "http://purl.org/dc/terms/dc_alternate", name_for_application_usage: 'alternate')
        @predicate_set.predicate_presentation_sequences.create!(presentation_sequence: 2, predicate: @alternate_predicate)
      end

      let(:property) { Property.new(predicate: 'title', values: ['Hello', 'World']) }
      let(:work) do
        Work.new(work_type: 'article') do |work|
          work.properties << property
        end
      end

      it 'should assign a work type' do
        expect(work.work_type).to eq(@article.to_work_type)
      end

      it 'should retrieve, via a predicate, the property and values that were set' do
        expect(work.properties[:title].values).to eq(['Hello', 'World'])
      end
    end
  end
end

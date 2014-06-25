require 'spec_slow_helper'

module Hydramata
  module Work
    describe 'instantiate entity from persisted work type' do
      before do
        @article = Hydramata::Work::WorkTypes::Storage.create!(identity: 'article', name_for_application_usage: 'article')
        @predicate_set = Hydramata::Work::PredicateSets::Storage.create!(identity: 'required', work_type: @article, presentation_sequence: 1, name_for_application_usage: 'required')
        @title_predicate = Hydramata::Work::Predicates::Storage.create!(identity: "http://purl.org/dc/terms/dc_title", name_for_application_usage: 'title')
        @predicate_set.predicate_presentation_sequences.create!(presentation_sequence: 1, predicate: @title_predicate)
        @alternate_predicate = Hydramata::Work::Predicates::Storage.create!(identity: "http://purl.org/dc/terms/dc_alternate", name_for_application_usage: 'alternate')
        @predicate_set.predicate_presentation_sequences.create!(presentation_sequence: 2, predicate: @alternate_predicate)
      end

      let(:work) do
        Entity.new(work_type: 'article') do |work|
          work.properties << Property.new(predicate: 'http://purl.org/dc/terms/dc_title', values: ["Hello", "World"])
        end
      end

      it 'should have #fieldsets' do
        expect(work.work_type.fieldsets.size).to eq(1)
      end
    end
  end
end

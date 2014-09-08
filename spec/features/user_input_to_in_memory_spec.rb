require 'spec_active_record_helper'
require 'hydramata/works/work'
require 'hydramata/works/work_types/storage'
require 'hydramata/works/conversions/work_type'
require 'hydramata/works/conversions/property'
require 'hydramata/works/apply_user_input_to_work'

module Hydramata
  module Works
      describe 'User input to in memory' do
      include Conversions
      context 'for :new object' do
        let(:work) { Work.new(work_type: work_type_identity) }
        let(:user_input) do
          {
            attributes: {
              title: ['Hello', 'World', 'Bang!'],
              abstract: ['Long Text', 'Longer Text'],
              keyword: ['Programming']
            }
          }
        end

        it 'appends properties to the collaborating work object' do
          ApplyUserInputToWork.call(work: work, attributes: user_input.fetch(:attributes))

          expect(work.work_type).to eq(WorkType(work_type_identity))
          expect(work.properties.fetch(:title)).to eq(Property(:title, 'Hello', 'World', 'Bang!'))
          expect(work.properties.fetch(:abstract)).to eq(Property(:abstract, 'Long Text', 'Longer Text'))
          expect(work.properties.fetch(:keyword)).to eq(Property(:keyword, 'Programming'))
        end
      end

      context 'for :existing object' do
        let(:work) do
          Work.new(work_type: work_type_identity, property_value_strategy: :replace_values) do |work|
            work.property_value_strategy
            work.properties << { predicate: :title, values: ['One Fish', 'Two Fish']}
            work.properties << { predicate: :keyword, values: 'Programming'}
          end
        end
        let(:user_input) do
          {
            attributes: {
              title: ['Hello', 'World', 'Bang!'],
              abstract: ['Long Text', 'Longer Text']
            }
          }
        end

        it 'appends explicit properties to the collaborating work object' do
          ApplyUserInputToWork.call(work: work, attributes: user_input.fetch(:attributes), property_value_strategy: :replace_values)

          expect(work.work_type).to eq(WorkType(work_type_identity))
          expect(work.properties.fetch(:title)).to eq(Property(:title, 'Hello', 'World', 'Bang!'))
          expect(work.properties.fetch(:abstract)).to eq(Property(:abstract, 'Long Text', 'Longer Text'))
          expect(work.properties.fetch(:keyword)).to eq(Property(:keyword, 'Programming'))
        end
      end


      let(:predicate_title) { Predicates::Storage.new(identity: 'title') }
      let(:predicate_abstract) { Predicates::Storage.new(identity: 'abstract') }
      let(:predicate_keyword) { Predicates::Storage.new(identity: 'keyword') }
      let(:work_type) { WorkTypes::Storage.new(identity: work_type_identity) }
      let(:predicate_set_required) { PredicateSets::Storage.new(identity: 'required', work_type: work_type, presentation_sequence: 1) }
      let(:predicate_set_optional) { PredicateSets::Storage.new(identity: 'optional', work_type: work_type, presentation_sequence: 2) }
      let(:work_type_identity) { 'Special Work Type' }

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

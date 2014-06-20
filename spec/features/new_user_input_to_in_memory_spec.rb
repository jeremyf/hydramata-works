require 'spec_slow_helper'
require 'hydramata/work/work_types/storage'
require 'hydramata/work/conversions'

module Hydramata
  module Work
    class UserInputToEntityCoercer
      def self.call(collaborators = {})
        new(collaborators).call
      end
      attr_reader :input, :entity
      def initialize(collaborators = {})
        @input = collaborators.fetch(:input)
        @entity = collaborators.fetch(:entity)
      end

      def call
        entity.work_type = input.fetch(:work_type)
        input.each do |predicate, values|
          next if predicate.to_s == 'work_type'
          entity.properties << { predicate: predicate, values: values }
        end
        entity
      end
    end

    describe 'New user input to in memory' do
      include Conversions

      it 'should create an appropriate object' do
        UserInputToEntityCoercer.call(entity: entity, input: input.fetch(:work))

        expect(entity.work_type).to eq(WorkType('Special Work Type'))
        expect(entity.properties.fetch(:title)).to eq(Property(:title, 'Hello', 'World', 'Bang!'))
        expect(entity.properties.fetch(:abstract)).to eq(Property(:abstract, 'Long Text', 'Longer Text'))
        expect(entity.properties.fetch(:keyword)).to eq(Property(:keyword, 'Programming'))
      end

      let(:input) do
        {
          work: {
            work_type: 'Special Work Type',
            title: ['Hello', 'World', 'Bang!'],
            abstract: ['Long Text', 'Longer Text'],
            keyword: ['Programming']
          }
        }
      end

      let(:predicate_title) { Predicates::Storage.new(identity: 'title') }
      let(:predicate_abstract) { Predicates::Storage.new(identity: 'abstract') }
      let(:predicate_keyword) { Predicates::Storage.new(identity: 'keyword') }
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

      let(:entity) { Entity.new }

    end
  end
end

require 'active_record'
require 'hydramata/work/predicate_set'
require 'hydramata/work/work_types/storage'
require 'hydramata/work/predicates/storage'
require 'hydramata/work/predicate_presentation_sequences/storage'

module Hydramata
  module Work
    module PredicateSets
      class Storage < ActiveRecord::Base
        self.table_name = :hydramata_work_predicate_sets
        belongs_to(
          :work_type,
          class_name: '::Hydramata::Work::WorkTypes::Storage',
          foreign_key: 'work_type_id'
        )
        validates :identity, uniqueness: { scope: :work_type_id }
        validates :presentation_sequence, uniqueness: { scope: :work_type_id }

        has_many(
          :predicate_presentation_sequences,
          class_name: '::Hydramata::Work::PredicatePresentationSequences::Storage',
          foreign_key: 'predicate_set_id'
        )

        has_many(
          :predicates,
          class_name: '::Hydramata::Work::Predicates::Storage',
          through: :predicate_presentation_sequences
        )

        def to_predicate_set
          PredicateSet.new(predicate_set_attributes)
        end

        private

        def predicate_set_attributes
          attributes.with_indifferent_access.merge(predicates: predicates, work_type: work_type)
        end

      end
    end
  end
end

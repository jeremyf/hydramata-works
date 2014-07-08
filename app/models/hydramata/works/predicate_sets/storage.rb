require 'active_record'
require 'hydramata/works/predicate_set'
require 'hydramata/works/work_types/storage'
require 'hydramata/works/predicates/storage'
require 'hydramata/works/predicate_presentation_sequences/storage'

module Hydramata
  module Works
    module PredicateSets
      class Storage < ActiveRecord::Base
        self.table_name = :hydramata_works_predicate_sets
        belongs_to(
          :work_type,
          class_name: '::Hydramata::Works::WorkTypes::Storage',
          foreign_key: 'work_type_id'
        )
        validates :identity, uniqueness: { scope: :work_type_id }
        validates :presentation_sequence, uniqueness: { scope: :work_type_id }

        has_many(
          :predicate_presentation_sequences,
          class_name: '::Hydramata::Works::PredicatePresentationSequences::Storage',
          foreign_key: 'predicate_set_id'
        )

        has_many(
          :predicates,
          class_name: '::Hydramata::Works::Predicates::Storage',
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

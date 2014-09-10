require 'active_record'
require 'hydramata/works/predicates/storage'
require 'hydramata/works/predicate_sets/storage'
require 'hydramata/works/predicates/storage'

module Hydramata
  module Works
    # Defines the order in which predicates are presented.
    module PredicatePresentationSequences
      class Storage < ActiveRecord::Base
        self.table_name = :hydramata_works_predicate_presentation_sequences

        default_scope { order(arel_table[:predicate_set_id].asc).order(arel_table[:presentation_sequence].asc) }

        validates :predicate_set_id, { presence: true }
        validates :predicate_id, { presence: true, uniqueness: { scope: :predicate_set_id } }
        validates :presentation_sequence, { presence: true, uniqueness: { scope: :predicate_set_id } }

        belongs_to(
          :predicate_set,
          class_name: '::Hydramata::Works::PredicateSets::Storage',
          foreign_key: 'predicate_set_id'
        )
        belongs_to(
          :predicate,
          class_name: '::Hydramata::Works::Predicates::Storage',
          foreign_key: 'predicate_id'
        )
      end
    end
  end
end

require 'active_record'
require 'hydramata/work/predicates/storage'
require 'hydramata/work/predicate_sets/storage'

module Hydramata
  module Work
    # Defines the order in which predicates are presented.
    module PredicatePresentationSequences
      class Storage < ActiveRecord::Base
        self.table_name = :hydramata_work_predicate_presentation_sequences

        validates :predicate_set_id, { presence: true }
        validates :predicate_id, { presence: true, uniqueness: { scope: :predicate_set_id } }
        validates :presentation_sequence, { presence: true, uniqueness: { scope: :predicate_set_id } }

        belongs_to(
          :predicate_set,
          class_name: 'Hydramata::Work::PredicateSets::Storage',
          foreign_key: 'predicate_set_id'
        )
        belongs_to(
          :predicate,
          class_name: 'Hydramata::Work::Predicates::Storage',
          foreign_key: 'predicate_id'
        )
      end
    end
  end
end

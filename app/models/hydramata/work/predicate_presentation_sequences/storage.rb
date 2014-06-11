require 'active_record'
require 'hydramata/work/predicate_presentation_sequences/storage'

module Hydramata
  module Work
    # Defines the order in which predicates are presented.
    module PredicatePresentationSequences
      class Storage < ActiveRecord::Base
        self.table_name = :hydramata_work_predicate_presentation_sequences
      end
    end
  end
end

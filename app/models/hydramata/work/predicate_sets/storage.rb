require 'active_record'
require 'hydramata/work/work_types/storage'

module Hydramata
  module Work
    module PredicateSets
      class Storage < ActiveRecord::Base
        self.table_name = :hydramata_work_predicate_sets
        belongs_to :work_type, class_name: 'Hydramata::Work::WorkTypes::Storage'
      end
    end
  end
end

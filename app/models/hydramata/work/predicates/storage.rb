require 'active_record'
module Hydramata
  module Work
    module Predicates
      # I don't want to conflate the idea with the predicate, with the storage
      # strategy for predicates.
      class Storage < ActiveRecord::Base
        self.table_name = :hydramata_work_predicates
        def self.find_by_identity(identity)
          where(identity: identity).first
        end
      end
    end
  end
end

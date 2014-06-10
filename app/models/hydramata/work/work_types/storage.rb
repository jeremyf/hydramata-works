require 'active_record'
module Hydramata
  module Work
    module WorkTypes
      # I don't want to conflate the idea with the predicate, with the storage
      # strategy for predicates.
      class Storage < ActiveRecord::Base
        self.table_name = :hydramata_work_types
        def self.find_by_identity!(identity)
          where(identity: identity).first!
        end

        def self.existing_attributes_for(identity)
          find_by_identity!(identity).attributes
        rescue ActiveRecord::RecordNotFound
          { identity: identity }
        rescue ActiveRecord::ConnectionNotEstablished
          # This is a potentially big deal in production.
          # But for testing, I don't always want to hit the database, so
          # I'm capturing this exception
          { identity: identity }
        end
      end
    end
  end
end

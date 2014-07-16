require 'active_record'
require 'hydramata/works/predicates'

module Hydramata
  module Works
    module Predicates
      # I don't want to conflate the idea with the predicate, with the storage
      # strategy for predicates.
      class Storage < ActiveRecord::Base
        self.table_name = :hydramata_works_predicates

        def self.find_by_identity!(identity)
          where(identity: identity).first!
        rescue ActiveRecord::RecordNotFound
          where(name_for_application_usage: identity).first!
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

        def to_predicate
          Predicate.new(attributes)
        end
      end
    end
  end
end

require 'active_record'
require 'hydramata/work/predicate_sets/storage'
require 'hydramata/work/work_type'

module Hydramata
  module Work
    module WorkTypes
      # I don't want to conflate the idea with the predicate, with the storage
      # strategy for predicates.
      class Storage < ActiveRecord::Base
        self.table_name = :hydramata_work_types
        has_many :predicate_sets, class_name: '::Hydramata::Work::PredicateSets::Storage', foreign_key: 'work_type_id'
        validates :identity, uniqueness: true, presence: true

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

        def to_work_type
          WorkType.new(attributes)
        end
      end
    end
  end
end

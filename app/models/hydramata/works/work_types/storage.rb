require 'active_record'
require 'hydramata/works/predicate_sets/storage'
require 'hydramata/works/work_type'

module Hydramata
  module Works
    module WorkTypes
      # I don't want to conflate the idea with the predicate, with the storage
      # strategy for predicates.
      class Storage < ActiveRecord::Base
        self.table_name = :hydramata_works_types
        has_many(
          :predicate_sets,
          class_name: '::Hydramata::Works::PredicateSets::Storage',
          foreign_key: 'work_type_id'
        )

        has_many(
          :predicate_presentation_sequences,
          class_name: '::Hydramata::Works::PredicatePresentationSequences::Storage',
          through: :predicate_sets
        )

        has_many(
          :predicates,
          class_name: '::Hydramata::Works::Predicates::Storage',
          through: :predicate_sets
        )

        validates :identity, uniqueness: true, presence: true

        def self.find_by_identity!(identity)
          where(identity: identity).first!
        rescue ActiveRecord::RecordNotFound
          where(name_for_application_usage: identity).first!
        end

        def self.existing_attributes_for(identity)
          # @TODO - Is this the pattern I want to pursue? I liked the method
          # :as_work_type being private
          find_by_identity!(identity).as_work_type
        rescue ActiveRecord::RecordNotFound
          { identity: identity }
        rescue ActiveRecord::ConnectionNotEstablished
          # This is a potentially big deal in production.
          # But for testing, I don't always want to hit the database, so
          # I'm capturing this exception
          { identity: identity }
        end

        scope :ordered, ->{ order(arel_table[:identity].asc) }

        def to_work_type(options = {})
          WorkType.new(as_work_type(options))
        end

        def as_work_type(options = {})
          shallow = options.fetch(:shallow) { false }
          if shallow
            attributes
          else
            attributes.merge(predicate_sets: predicate_sets)
          end
        end
      end
    end
  end
end

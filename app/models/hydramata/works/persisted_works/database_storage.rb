require 'active_record'
require 'hydramata/works/work'

module Hydramata
  module Works
    module PersistedWorks
      class DatabaseStorage < ActiveRecord::Base
        self.table_name = :hydramata_works_works
        self.primary_key = :pid
        serialize :properties, Hash

        alias_attribute :identity, :pid

        has_many(
          :attachments,
          class_name: 'Hydramata::Works::Attachments::DatabaseStorage',
          foreign_key: 'work_id'
        )

        def to_work
          Work.new(identity: pid, work_type: work_type, state: state) do |work|
            attachments.each do |attachment|
              work.properties << { predicate: attachment.predicate, values: attachment }
            end
            properties.each do |predicate, values|
              work.properties << { predicate: predicate, values: values }
            end
          end
        end
      end
    end
  end
end

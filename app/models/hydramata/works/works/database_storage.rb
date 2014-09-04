require 'active_record/base'
require 'hydramata/works/work'

module Hydramata
  module Works
    module Works
      class DatabaseStorage < ActiveRecord::Base
        self.table_name = :hydramata_works_works
        self.primary_key = :pid
        serialize :properties, Hash

        def self.find_or_create_by_pid(attributes = {})
          pid = attributes.fetch(:pid)
          work = where(pid: pid).first || new(pid: pid)
          work.work_type = attributes[:work_type] if attributes.key?(:work_type)
          work.state = attributes[:state] if attributes[:state]
          if attributes.key?(:properties)
            work.properties ||= {}
            attributes[:properties].each do |key ,value|
              if value
                work.properties[key] = value
              else
                work.properties.delete(key)
              end
            end
          end
          work.save
        end

        def to_work
          Work.new(identity: pid, work_type: work_type, state: state) do |work|
            properties.each do |predicate, values|
              work.properties << { predicate: predicate, values: values }
            end
          end
        end
      end
    end
  end
end

require 'active_record/base'
require 'hydramata/works/work'

module Hydramata
  module Works
    module Works
      class DatabaseStorage < ActiveRecord::Base
        self.table_name = :hydramata_works_works
        serialize :properties, Hash

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

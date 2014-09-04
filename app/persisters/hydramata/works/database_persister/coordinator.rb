require 'active_support/core_ext/object/blank'

module Hydramata
  module Works
    class DatabasePersister
      module Coordinator
        module_function
        def call(attributes = {}, storage = Works::DatabaseStorage)
          pid = attributes.fetch(:pid)
          work = storage.find_or_initialize_by(pid: pid)
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
      end
    end
  end
end

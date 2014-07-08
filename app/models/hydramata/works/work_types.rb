require 'hydramata/works/work_type'
require 'hydramata/works/work_types/storage'

module Hydramata
  module Works
    module WorkTypes
      module_function
      def find(identity, attributes = {})
        work_type_attributes = attributes.merge(WorkTypes::Storage.existing_attributes_for(identity))
        WorkType.new(work_type_attributes)
      end
    end
  end
end

require 'active_support/core_ext/object/blank'

module Hydramata
  module Works
    # Responsible for negotiating an object from persistence into memory
    module FromPersistence
      module_function
      def call(options = {})
        pid = options.fetch(:pid)
        Hydramata.configuration.work_from_persistence_coordinator.call(pid: pid)
      end
    end
  end
end

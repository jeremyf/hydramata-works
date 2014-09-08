module Hydramata
  module Works
    module ConfigurationMethods
      def work_model_name
        @work_model_name ||= 'Work'
      end

      def work_model_name=(string)
        @work_model_name = string
      end

      def work_storage_service
        @work_storage_service ||= begin
          require 'hydramata/works/persister/database_coordinator'
          Persister::DatabaseCoordinator
        end
      end

      def work_storage_service=(object)
        if object.respond_to?(:call)
          @work_storage_service = object
        else
          raise RuntimeError, "Expected #{object.inspect} to respond_to :call"
        end
      end
    end
  end
end

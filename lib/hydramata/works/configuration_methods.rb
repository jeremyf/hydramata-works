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

      def work_storage_service=(callable)
        if callable.respond_to?(:call)
          @work_storage_service = callable
        else
          raise RuntimeError, "Expected #{callable.inspect} to respond_to :call"
        end
      end

      def pid_minting_service
        @pid_minting_service ||= begin
          -> { rand(100_000_000).to_s }
        end
      end

      def pid_minting_service=(callable)
        if callable.respond_to?(:call)
          @pid_minting_service = callable
        else
          raise RuntimeError, "Expected #{callable.inspect} to respond_to :call"
        end
      end
    end
  end
end

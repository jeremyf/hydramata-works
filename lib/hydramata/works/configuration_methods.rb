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

      def repository_connection
        @repository_connection ||= begin
        require 'rubydora'
        # Please note: these parameters were used in building the VCR cassettes, so change at your own risk.
        # TODO: This should be a configuration option analogous to ActiveFedora.
        Rubydora.connect(url: 'http://127.0.0.1:8983/fedora', user: 'fedoraAdmin', password: 'fedoraAdmin')
        end
      end

      def repository_connection=(connection)
        if connection.respond_to?(:find_or_initialize)
          @repository_connection = connection
        else
          raise RuntimeError, "Expected #{connection.inspect} to respond_to :find_or_initialize"
        end
      end
    end
  end
end

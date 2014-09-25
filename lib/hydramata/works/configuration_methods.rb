module Hydramata
  module Works
    module ConfigurationMethods
      def work_model_name
        @work_model_name ||= default_work_model_name
      end

      def work_model_name=(string)
        @work_model_name = String(string)
      end

      def default_work_model_name
        'Work'
      end
      private :default_work_model_name

      def work_to_persistence_coordinator
        @work_to_persistence_coordinator ||= default_work_to_persistence_coordinator
      end

      def work_to_persistence_coordinator=(callable)
        if callable.respond_to?(:call)
          @work_to_persistence_coordinator = callable
        else
          raise RuntimeError, "Expected #{callable.inspect} to respond_to :call"
        end
      end

      def default_work_to_persistence_coordinator
        require 'hydramata/works/to_persistence/database_coordinator'
        ToPersistence::DatabaseCoordinator
      end
      private :default_work_to_persistence_coordinator

      def pid_minting_service
        @pid_minting_service ||= default_pid_minting_service
      end

      def pid_minting_service=(callable)
        if callable.respond_to?(:call)
          @pid_minting_service = callable
        else
          raise RuntimeError, "Expected #{callable.inspect} to respond_to :call"
        end
      end

      def default_pid_minting_service
        -> { "opaque:#{rand(100_000_000)}" }
      end
      private :default_pid_minting_service

      def repository_connection
        @repository_connection ||= default_repository_connection
      end

      def repository_connection=(connection)
        if connection.respond_to?(:find_or_initialize)
          @repository_connection = connection
        else
          raise RuntimeError, "Expected #{connection.inspect} to respond_to :find_or_initialize"
        end
      end

      def default_repository_connection
        require 'rubydora'
        # Please note: these parameters were used in building the VCR cassettes, so change at your own risk.
        # TODO: This should be a configuration option analogous to ActiveFedora.
        Rubydora.connect(url: 'http://127.0.0.1:8983/fedora', user: 'fedoraAdmin', password: 'fedoraAdmin')
      end
      private :default_repository_connection

      def work_from_persistence_coordinator
        @work_from_persistence_coordinator ||= default_work_from_persistence_coordinator
      end

      def work_from_persistence_coordinator=(callable)
        if callable.respond_to?(:call)
          @work_from_persistence_coordinator = callable
        else
          raise RuntimeError, "Expected #{callable.inspect} to respond_to :call"
        end
      end

      def default_work_from_persistence_coordinator
        lambda do |options|
          pid = options.fetch(:pid)
          PersistedWorks::DatabaseStorage.where(pid: pid).
            first!.
            to_work
        end
      end
      private :default_work_from_persistence_coordinator

    end
  end
end

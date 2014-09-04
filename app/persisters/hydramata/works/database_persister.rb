require 'active_support/core_ext/object/blank'

module Hydramata
  module Works
    # Responsible for negotiating an in-memory work through to the database via
    # the #storage_service method.
    #
    # @TODO - Consider storing the database record in the same format as the
    # show.json object
    #
    # @TODO - Consider creating two persisters. One of the PID exists. Another
    # if the PID does not exist. There are if statements happening, and service
    # logic mixing into the storage_service.
    module DatabasePersister
      module_function
      def call(collaborators = {})
        new(collaborators).call
      end

      def new(collaborators)
        work = collaborators.fetch(:work)
        if work.identity.present?
          PersisterCoordinator.new(collaborators) do |builder|
            builder.storage_service = collaborators.fetch(:storage_service) { PersistWithIdentity }
          end
        else
          PersisterCoordinator.new(collaborators) do |builder|
            builder.pid = builder.get_next_pid
            builder.storage_service = collaborators.fetch(:storage_service) { PersistWithoutIdentity }
          end
        end
      end

      class PersisterCoordinator
        attr_reader :properties, :files, :state, :work, :storage_service, :pid_minting_service
        attr_writer :pid, :storage_service
        private :storage_service, :pid_minting_service
        def initialize(collaborators = {})
          @work = collaborators.fetch(:work)
          @state = collaborators[:state]
          @pid_minting_service = collaborators.fetch(:pid_minting_service) { default_pid_minting_service }
          yield(self) if block_given?
          assign_properties!
          freeze
        end

        def call
          if storage_service.call(attributes_to_persist)
            work.identity ||= pid
            true
          else
            false
          end
        end

        def pid
          @pid || work.identity || get_next_pid
        end

        def get_next_pid
          pid_minting_service.call
        end

        private

        def work_type
          work.work_type.to_s
        end

        def attributes_to_persist
          { pid: pid, work_type: work_type, properties: properties, state: state, files: files }
        end

        def assign_properties!
          @properties = {}
          @files = {}
          work.properties.each do |property|
            property.values.each do |value|
              if value.respond_to?(:raw_object) && value.raw_object.respond_to?(:original_filename)
                @files[property.name.to_s] ||= []
                @files[property.name.to_s] << value.raw_object
              else
                @properties[property.name.to_s] ||= []
                @properties[property.name.to_s] << value.to_s
              end
            end
          end
        end

        def default_pid_minting_service
          lambda { rand(100_000_000).to_s }
        end
      end
      private_constant :PersisterCoordinator

      module PersistWithIdentity
        module_function
        def call(attributes)
          Works::DatabaseStorage.find_or_create_by_pid(attributes) ? true : false
        end
      end
      private_constant :PersistWithIdentity

      module PersistWithoutIdentity
        module_function
        def call(attributes)
          Works::DatabaseStorage.find_or_create_by_pid(attributes) ? true : false
        end
      end
      private_constant :PersistWithoutIdentity
    end
  end
end

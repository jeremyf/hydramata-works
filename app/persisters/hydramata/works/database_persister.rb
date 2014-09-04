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
    class DatabasePersister
      def self.call(collaborators = {})
        new(collaborators).call
      end


      attr_reader :properties, :attachments, :state, :work, :storage_service, :pid_minting_service, :pid
      private :storage_service, :pid_minting_service
      def initialize(collaborators = {})
        @work = collaborators.fetch(:work)
        @state = collaborators[:state]
        @pid_minting_service = collaborators.fetch(:pid_minting_service) { default_pid_minting_service }
        @storage_service = collaborators.fetch(:storage_service) { default_storage_service }
        assign_pid!
        # yield(self) if block_given?
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

      private

      def assign_pid!
        @pid ||= ( work.identity || pid_minting_service.call )
      end

      def work_type
        work.work_type.to_s
      end

      def attributes_to_persist
        { pid: pid, work_type: work_type, properties: properties, state: state, attachments: attachments }
      end

      def assign_properties!
        @properties = {}
        @attachments = {}
        work.properties.each do |property|
          property.values.each do |value|
            if value.respond_to?(:raw_object) && value.raw_object.respond_to?(:original_filename)
              @attachments[property.name.to_s] ||= []
              @attachments[property.name.to_s] << value.raw_object
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

      def default_storage_service
        require 'hydramata/works/database_persister/coordinator'
        Coordinator
      end
    end
  end
end

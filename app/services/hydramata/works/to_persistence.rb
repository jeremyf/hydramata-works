require 'active_support/core_ext/object/blank'

module Hydramata
  module Works
    # Responsible for negotiating an in-memory work through to the database via
    # the #persistence_coordinator method.
    class ToPersistence
      def self.call(collaborators = {})
        new(collaborators).call
      end

      attr_reader :properties, :attachments, :state, :work, :persistence_coordinator, :pid_minting_service, :pid
      private :persistence_coordinator, :pid_minting_service
      def initialize(collaborators = {})
        @work = collaborators.fetch(:work)
        @state = collaborators[:state]
        @pid_minting_service = collaborators.fetch(:pid_minting_service) { default_pid_minting_service }
        @persistence_coordinator = collaborators.fetch(:persistence_coordinator) { default_persistence_coordinator }
        assign_pid!
        assign_properties!
        freeze
      end

      def call
        if persistence_coordinator.call(attributes_to_persist, pid_minting_service: pid_minting_service)
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
            # Casess to parse:
            #
            # * existing attachment
            # * new attachment
            # * simple value
            if value.respond_to?(:raw_object)
              if value.raw_object.respond_to?(:file_name)
                @attachments[property.predicate] ||= []
                @attachments[property.predicate] << value.raw_object
              elsif value.raw_object.respond_to?(:original_filename)
                @attachments[property.predicate] ||= []
                @attachments[property.predicate] << value.raw_object
              else
                @properties[property.predicate] ||= []
                @properties[property.predicate] << value.to_s
              end
            else
              @properties[property.predicate] ||= []
              @properties[property.predicate] << value.to_s
            end
          end
        end
      end

      def default_pid_minting_service
        Hydramata.configuration.pid_minting_service
      end

      def default_persistence_coordinator
        Hydramata.configuration.work_to_persistence_coordinator
      end
    end
  end
end

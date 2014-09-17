require 'active_support/core_ext/object/blank'
require 'hydramata/works/conversions/work_type'

module Hydramata
  module Works
    # Responsible for negotiating an in-memory work through to the database via
    # the #persistence_coordinator method.
    class ToPersistence
      include Conversions
      def self.call(collaborators = {})
        new(collaborators).call
      end

      attr_reader :properties, :attachments, :state, :work, :pid, :dettachments
      attr_reader :persistence_coordinator, :pid_minting_service
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
        WorkType(work.work_type).identity
      end

      def attributes_to_persist
        {
          pid: pid, work_type: work_type, state: state,
          properties: properties, attachments: attachments, dettachments: dettachments
        }
      end

      def assign_properties!
        @properties = {}
        @attachments = {}
        @dettachments = {}
        work.properties.each do |property|
          property.values.each do |value|
            # Casess to parse:
            #
            # * existing attachment
            # * new attachment
            # * removing an attachment
            # * simple value
            #
            # @TODO - Yuck! Noodle on this solution. Its ugly.
            # I believe the value parser should yield for the appropriate
            # callback types.
            if value.respond_to?(:raw_object)
              if value.raw_object.respond_to?(:file_name)
                @attachments[property.predicate] ||= []
                @attachments[property.predicate] << value.raw_object
              elsif value.raw_object.respond_to?(:original_filename)
                @attachments[property.predicate] ||= []
                @attachments[property.predicate] << value.raw_object
              elsif value.raw_object.is_a?(Hash)
                if value.raw_object.key?(:delete)
                  @dettachments[property.predicate] ||= []
                  to_delete = value.raw_object.fetch(:delete, []).flatten
                  Array.wrap(to_delete).each do |attachment|
                    @dettachments[property.predicate] << attachment
                  end
                else
                  @properties[property.predicate] ||= []
                  @properties[property.predicate] << value.raw_object
                end
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

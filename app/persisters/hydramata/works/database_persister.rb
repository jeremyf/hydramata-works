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

      attr_reader :pid, :properties
      def initialize(collaborators = {})
        @work = collaborators.fetch(:work)
        @state = collaborators[:state]
        @storage_service = collaborators.fetch(:storage_service) { default_storage_service }
        @pid_minting_service = collaborators.fetch(:pid_minting_service) { default_pid_minting_service }
        assign_a_pid!
        assign_properties!
        freeze
      end

      def call
        # Using work_type.to_s because ActiveRecord does a half-hearted attempt
        # to coerce the object to a String.
        # See https://github.com/rails/rails/blob/4-1-stable/activerecord/lib/active_record/connection_adapters/abstract/quoting.rb#L45-L78
        #
        # Yes I could define :quote_id and :id on data definitions, but I
        # have yet to take the time to consider this implication.
        if storage_service.call(attributes_to_persist)
          work.identity = pid unless work.identity.present?
          true
        else
          false
        end
      end

      attr_reader :work, :storage_service, :pid_minting_service, :state
      private :work, :storage_service, :pid_minting_service, :state

      def work_type
        work.work_type
      end

      private

      def attributes_to_persist
        attrs = {
          pid: pid,
          work_type: work_type.to_s,
          properties: properties
        }
        attrs[:state] = state if state
        attrs
      end

      def default_storage_service
        require 'hydramata/works/works/database_storage'
        if work.identity.present?
          Works::DatabaseStorage.method(:find_or_create_by_pid)
        else
          Works::DatabaseStorage.method(:create)
        end
      end

      def default_pid_minting_service
        if work.identity.present?
          lambda { work.identity }
        else
          # @TODO - This is not the final form, but a placeholder
          lambda { rand(100000).to_s }
        end
      end

      def assign_a_pid!
        @pid = pid_minting_service.call
      end

      def assign_properties!
        @properties = {}
        work.properties.each do |property|
          # Because I want primative values stored, instead of the possible
          # complex objects.
          @properties[property.name.to_s] = property.values.collect(&:to_s)
        end
      end
    end
  end
end

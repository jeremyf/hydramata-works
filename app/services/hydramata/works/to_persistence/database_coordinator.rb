require 'active_support/core_ext/array/wrap'
require 'hydramata/works/conversions/predicate'

module Hydramata
  module Works
    class ToPersistence
      class DatabaseCoordinator
        include Conversions
        def self.call(attributes = {}, collaborators = {})
          new(attributes, collaborators).call
        end

        attr_reader :work, :attributes, :collaborators
        private :work, :attributes, :collaborators
        def initialize(attributes = {}, collaborators = {})
          @property_storage = collaborators.fetch(:property_storage) { default_property_storage }
          @attachment_storage = collaborators.fetch(:attachment_storage) { default_attachment_storage }
          @pid_minting_service = collaborators.fetch(:pid_minting_service) { pid_minting_service }
          pid = attributes.fetch(:pid)
          @work = property_storage.find_or_initialize_by(pid: pid)
          @attributes = attributes
        end

        def call
          work.work_type = attributes[:work_type] if attributes.key?(:work_type)
          work.state = attributes[:state] if attributes[:state]
          append_properties
          work.save! && append_attachments && remove_dettachments
        end

        private

        def append_properties
          return true unless attributes[:properties]
          work.properties ||= {}
          attributes[:properties].each do |key ,values|
            predicate = Predicate(key)
            if values
              work.properties[predicate.name] = values
            else
              work.properties.delete(predicate.name)
            end
          end
        end

        def each_value_for_attribute_key(key_name)
          return true unless attributes[key_name]
          attributes[key_name].all? do |key, values|
            predicate = Predicate(key)
            Array.wrap(values).each do |value|
              next if value.blank?
              yield(predicate, value)
            end
          end
        end

        def append_attachments
          each_value_for_attribute_key(:attachments) do |predicate, file|
            next if file.is_a?(attachment_storage) && file.persisted?
            attachment_pid = pid_minting_service.call
            attachment_storage.
              create!(pid: attachment_pid, work_id: work.identity, predicate: predicate.name, file: file)
          end
        end

        def remove_dettachments
          each_value_for_attribute_key(:dettachments) do |predicate, identity|
            attachment_storage.
              where(work_id: work.identity, predicate: predicate.name, pid: identity).
              destroy_all
          end
        end

        attr_reader :property_storage
        private :property_storage
        def default_property_storage
          require 'hydramata/works/persisted_works/database_storage'
          PersistedWorks::DatabaseStorage
        end

        attr_reader :attachment_storage
        private :attachment_storage
        def default_attachment_storage
          require 'hydramata/works/attachments/database_storage'
          Attachments::DatabaseStorage
        end

        attr_reader :pid_minting_service
        private :pid_minting_service
        def default_pid_minting_service
          Hydramata.configuration.pid_minting_service
        end

      end
    end
  end
end

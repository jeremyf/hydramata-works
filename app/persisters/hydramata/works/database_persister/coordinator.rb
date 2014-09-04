require 'active_support/core_ext/array/wrap'

module Hydramata
  module Works
    class DatabasePersister
      class Coordinator
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
          work.save! && append_attachments
        end

        private

        def append_properties
          return true unless attributes[:properties]
          work.properties ||= {}
          attributes[:properties].each do |predicate ,values|
            if values
              work.properties[predicate] = values
            else
              work.properties.delete(predicate)
            end
          end
        end

        def append_attachments
          return true unless attributes[:attachments]
          attributes[:attachments].all? do |predicate, attachments|
            Array.wrap(attachments).each do |attachment|
              attachment_pid = pid_minting_service.call
              attachment_storage.create!(
                pid: attachment_pid,
                work_id: work.identity,
                predicate: predicate,
                attachment: attachment
              )
            end
          end
        end

        attr_reader :property_storage
        private :property_storage
        def default_property_storage
          require 'hydramata/works/works/database_storage'
          Works::DatabaseStorage
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
          lambda { rand(100_000_000).to_s }
        end

      end
    end
  end
end

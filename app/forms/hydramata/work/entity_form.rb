require 'delegate'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'
require 'active_model/naming'

module Hydramata
  module Work
    class EntityForm < SimpleDelegator

      def initialize(entity, collaborators = {})
        __setobj__(entity)
        @errors = collaborators.fetch(:error_container) { default_error_container }
      end

      attr_reader :errors

      def inspect
        format('#<%s:%#0x entity=%s>', EntityForm, __id__, __getobj__.inspect)
      end

      def to_key
        persisted? ? [identity] : nil
      end

      def to_param
        persisted? ? identity : nil
      end

      def to_partial_path
        # @TODO - need to figure out what this should be
        ''
      end

      def persisted?
        identity.present?
      end

      def self.model_name
        # @TODO - allow overwrite of the ActiveModel::Name, which may require
        # overwriting #class to be something else.
        @_model_name ||= ActiveModel::Name.new(self, Hydramata::Work)
      end

      private

      def default_error_container
        require 'active_model/errors'
        ActiveModel::Errors.new(self)
      end
    end
  end
end

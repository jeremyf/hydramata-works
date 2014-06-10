require 'hydramata/work/base_presenter'

module Hydramata
  module Work
    # Responsible for coordinating the rendering of an in-memory
    # PropertySet-like object to an output buffer.
    #
    # @TODO - Rename fieldset in presentation to property_set
    class FieldsetPresenter < BasePresenter
      attr_reader :entity
      def initialize(collaborators = {})
        fieldset = collaborators.fetch(:fieldset)
        @entity = collaborators.fetch(:entity)
        super(fieldset, collaborators)
      end

      def work_type
        entity.work_type
      end

      private

      def default_presentation_context
        entity.respond_to?(:presentation_context) ? entity.presentation_context : 'show'
      end

      def view_path_slug_for_object
        'fieldsets'
      end

      def default_partial_prefixes
        entity_prefix = String(entity.work_type).downcase.gsub(/\W+/, '_')
        fieldset_prefix = String(name).gsub(/\W+/, '_')
        [File.join(entity_prefix, fieldset_prefix), fieldset_prefix]
      end
    end
  end
end

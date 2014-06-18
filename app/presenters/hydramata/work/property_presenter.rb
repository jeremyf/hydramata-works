require 'hydramata/work/base_presenter'
module Hydramata
  module Work
    # Responsible for coordinating the rendering of an in-memory Property-like
    # object to an output buffer.
    class PropertyPresenter < BasePresenter
      attr_reader :fieldset, :entity
      def initialize(collaborators = {})
        property = collaborators.fetch(:property)
        @fieldset = collaborators.fetch(:fieldset)
        @entity = collaborators.fetch(:entity)
        super(property, collaborators)
      end

      private

      def default_presentation_context
        entity.respond_to?(:presentation_context) ? entity.presentation_context : 'show'
      end

      def view_path_slug_for_object
        'properties'
      end

      def default_partial_prefixes
        entity_prefix = normalize_for_application_usage(entity.work_type)
        predicate_prefix = normalize_for_application_usage(predicate)
        [File.join(entity_prefix, predicate_prefix), predicate_prefix]
      end

    end
  end
end

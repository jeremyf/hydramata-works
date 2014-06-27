require 'hydramata/work/base_presenter'
module Hydramata
  module Work
    # Responsible for coordinating the rendering of an in-memory Property-like
    # object to an output buffer.
    class PropertyPresenter < BasePresenter
      attr_reader :entity
      def initialize(collaborators = {})
        property = collaborators.fetch(:property)
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
        entity_prefix = TranslationKeyFragment(entity)
        predicate_prefix = TranslationKeyFragment(predicate)
        [
          [entity_prefix, predicate_prefix],
          [predicate_prefix]
        ]
      end

      def default_translation_scopes
        entity_prefix = TranslationKeyFragment(entity)
        predicate_prefix = TranslationKeyFragment(predicate)
        [
          ['works', entity_prefix, view_path_slug_for_object, predicate_prefix],
          [view_path_slug_for_object, predicate_prefix]
        ]
      end
    end
  end
end

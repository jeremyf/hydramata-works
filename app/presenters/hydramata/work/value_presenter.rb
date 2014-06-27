require 'hydramata/work/base_presenter'
module Hydramata
  module Work
    # Responsible for coordinating the rendering of an in-memory Value-like
    # object to an output buffer.
    class ValuePresenter < BasePresenter
      attr_reader :entity, :predicate
      def initialize(collaborators = {})
        value = collaborators.fetch(:value)
        @predicate = collaborators.fetch(:predicate)
        @entity = collaborators.fetch(:entity)
        super(value, collaborators)
      end

      private

      def name
        "#{predicate.name}_value"
      end

      def default_dom_attributes
        { class: [dom_class, presenter_dom_class] }
      end

      def default_presentation_context
        entity.respond_to?(:presentation_context) ? entity.presentation_context : 'show'
      end

      def view_path_slug_for_object
        'values'
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

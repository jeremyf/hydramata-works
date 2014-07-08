require 'hydramata/works/base_presenter'
module Hydramata
  module Works
    # Responsible for coordinating the rendering of an in-memory Property-like
    # object to an output buffer.
    class PropertyPresenter < BasePresenter
      attr_reader :entity, :value_presenter_builder
      private :value_presenter_builder
      def initialize(collaborators = {})
        property = collaborators.fetch(:property)
        @entity = collaborators.fetch(:entity)
        @value_presenter_builder = collaborators.fetch(:value_presenter_builder) { default_value_presenter_builder }
        super(property, collaborators)
      end

      def values
        @values ||= __getobj__.values.collect {|value| value_presenter_builder.call(value: value, predicate: self, entity: entity) }
      end

      private

      def default_dom_attributes
        { class: [dom_class, presenter_dom_class] }
      end

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

      def default_value_presenter_builder
        require 'hydramata/works/value_presenter'
        ValuePresenter.method(:new)
      end
    end
  end
end

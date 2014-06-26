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
        __getobj__.work_type || entity.work_type
      end

      def container_content_tag_attributes
        { class: dom_class}
      end

      private

      def default_presentation_context
        entity.respond_to?(:presentation_context) ? entity.presentation_context : 'show'
      end

      def view_path_slug_for_object
        'fieldsets'
      end

      def default_partial_prefixes
        entity_prefix = TranslationKeyFragment(entity.work_type)
        fieldset_prefix = TranslationKeyFragment(name)
        [
          [entity_prefix, fieldset_prefix],
          [fieldset_prefix]
        ]
      end

      def default_translation_scopes
        entity_prefix = TranslationKeyFragment(entity.work_type)
        fieldset_prefix = TranslationKeyFragment(name)
        [
          ['works', entity_prefix, view_path_slug_for_object, fieldset_prefix],
          [view_path_slug_for_object, fieldset_prefix]
        ]
      end
    end
  end
end

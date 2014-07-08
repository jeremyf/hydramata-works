require 'hydramata/works/base_presenter'

module Hydramata
  module Works
    # Responsible for coordinating the rendering of an in-memory
    # PropertySet-like object to an output buffer.
    #
    # @TODO - Rename fieldset in presentation to property_set
    class FieldsetPresenter < BasePresenter
      attr_reader :work
      def initialize(collaborators = {})
        fieldset = collaborators.fetch(:fieldset)
        @work = collaborators.fetch(:work)
        super(fieldset, collaborators)
      end

      def work_type
        __getobj__.work_type || work.work_type
      end

      private

      def default_dom_attributes
        { class: [dom_class, presenter_dom_class] }
      end

      def default_presentation_context
        work.respond_to?(:presentation_context) ? work.presentation_context : 'show'
      end

      def view_path_slug_for_object
        'fieldsets'
      end

      def default_partial_prefixes
        work_prefix = TranslationKeyFragment(work)
        fieldset_prefix = TranslationKeyFragment(name)
        [
          [work_prefix, fieldset_prefix],
          [fieldset_prefix]
        ]
      end

      def default_translation_scopes
        work_prefix = TranslationKeyFragment(work)
        fieldset_prefix = TranslationKeyFragment(name)
        [
          ['works', work_prefix, view_path_slug_for_object, fieldset_prefix],
          [view_path_slug_for_object, fieldset_prefix]
        ]
      end
    end
  end
end

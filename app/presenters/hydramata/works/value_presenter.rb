require 'hydramata/works/base_presenter'
module Hydramata
  module Works
    # Responsible for coordinating the rendering of an in-memory Value-like
    # object to an output buffer.
    class ValuePresenter < BasePresenter
      attr_reader :work, :predicate
      def initialize(collaborators = {})
        value = collaborators.fetch(:value)
        @predicate = collaborators.fetch(:predicate)
        @work = collaborators.fetch(:work)
        super(value, collaborators)
      end

      def render(*args, &block)
        begin
          super(*args, &block)
        rescue *template_missing_error
          __getobj__.to_s
        end
      end

      private

      def name
        "#{predicate.name}_value"
      end

      def default_dom_attributes
        { class: [dom_class, presenter_dom_class] }
      end

      def default_presentation_context
        work.respond_to?(:presentation_context) ? work.presentation_context : 'show'
      end

      def view_path_slug_for_object
        'values'
      end

      def default_partial_prefixes
        work_prefix = TranslationKeyFragment(work)
        predicate_prefix = TranslationKeyFragment(predicate)
        [
          [work_prefix, predicate_prefix],
          [predicate_prefix]
        ]
      end

      def default_translation_scopes
        work_prefix = TranslationKeyFragment(work)
        predicate_prefix = TranslationKeyFragment(predicate)
        [
          ['work_types', work_prefix, view_path_slug_for_object, predicate_prefix],
          [view_path_slug_for_object, predicate_prefix]
        ]
      end
    end
  end
end

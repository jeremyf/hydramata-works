require 'hydramata/works/base_presenter'

module Hydramata
  module Works
    # Responsible for coordinating the rendering of an in-memory Attachment
    # Value-like object to an output buffer.
    class AttachmentPresenter < BasePresenter
      attr_reader :work, :predicate, :remote_url_builder
      private :remote_url_builder
      def initialize(collaborators = {})
        value = collaborators.fetch(:value)
        @predicate = collaborators.fetch(:predicate)
        @work = collaborators.fetch(:work)
        @remote_url_builder = collaborators.fetch(:remote_url_builder) { default_remote_url_builder }
        super(value, collaborators)
      end

      def render(template, options = {})
        renderer.call(template, options) { label }
      end

      def view_path_slug_for_object
        'values'
      end

      def label
        __getobj__.to_s
      end

      def url
        remote_url_builder.call(raw_object.file_uid)
      end

      private

      def default_remote_url_builder
        require 'dragonfly'
        Dragonfly.app.method(:remote_url_for)
      end

      def default_dom_attributes
        { class: [dom_class, presenter_dom_class] }
      end

      def default_presentation_context
        work.respond_to?(:presentation_context) ? work.presentation_context : 'show'
      end

      def default_partial_prefixes
        work_prefix = ViewPathFragment(work)
        predicate_prefix = ViewPathFragment(predicate)
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

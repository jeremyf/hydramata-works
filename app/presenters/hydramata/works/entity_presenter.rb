require 'hydramata/works/conversions/presented_fieldsets'
require 'hydramata/works/base_presenter'

module Hydramata
  module Works
    # Responsible for coordinating the rendering of an in-memory Entity-like
    # object to an output buffer.
    class EntityPresenter < BasePresenter
      include Conversions

      attr_reader :presentation_structure, :presented_fieldset_builder
      def initialize(collaborators = {})
        entity = collaborators.fetch(:entity)
        super(entity, collaborators)
        @presentation_structure = collaborators.fetch(:presentation_structure) { default_presentation_structure }
        @presented_fieldset_builder = collaborators.fetch(:presented_fieldset_builder) { default_presented_fieldset_builder }
      end

      def fieldsets
        @fieldsets ||= presented_fieldset_builder.call(entity: self, presentation_structure: presentation_structure)
      end

      private

      def default_dom_attributes
        {
          :class => [dom_class, presenter_dom_class],
          :itemscope => true,
          :itemtype => itemtype_schema_dot_org
        }
      end

      def presenter_dom_class
        'work'
      end

      def view_path_slug_for_object
        'works'
      end

      def base_dom_class
        work_type.to_s.downcase.gsub(/[\W_]+/, '-')
      end

      def default_presented_fieldset_builder
        ->(collaborators) { PresentedFieldsets(collaborators) }
      end

      def default_partial_prefixes
        [
          [TranslationKeyFragment(self)]
        ]
      end

      def default_translation_scopes
        [
          ['works', TranslationKeyFragment(self)]
        ]
      end

      def default_presentation_structure
        work_type
      end

    end
  end
end

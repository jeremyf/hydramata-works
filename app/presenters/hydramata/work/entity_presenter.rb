require 'hydramata/work/conversions/presented_fieldsets'
require 'hydramata/work/base_presenter'

module Hydramata
  module Work
    # Responsible for coordinating the rendering of an in-memory Entity-like
    # object to an output buffer.
    class EntityPresenter < BasePresenter
      include Conversions

      attr_reader :entity, :presentation_structure, :presented_fieldset_builder
      def initialize(collaborators = {})
        @entity = collaborators.fetch(:entity)
        super(@entity, collaborators)
        # @TODO - Create default presentation structure; What would this look like?
        @presentation_structure = collaborators.fetch(:presentation_structure)
        @presented_fieldset_builder = collaborators.fetch(:presented_fieldset_builder) { default_presented_fieldset_builder }
      end

      def fieldsets
        @fieldsets ||= presented_fieldset_builder.call(entity: self, presentation_structure: presentation_structure)
      end

      private

      def view_path_slug_for_object
        'works'
      end

      def base_dom_class
        entity.work_type.to_s.downcase.gsub(/[\W_]+/, '-')
      end

      def default_presented_fieldset_builder
        ->(collaborators) { PresentedFieldsets(collaborators) }
      end

      def default_partial_prefixes
        [
          [TranslationKeyFragment(entity.work_type)]
        ]
      end

      def default_translation_scopes
        [
          ['works', TranslationKeyFragment(entity.work_type)]
        ]
      end

    end
  end
end

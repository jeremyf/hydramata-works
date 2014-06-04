require 'hydramata/work/base_presenter'
module Hydramata
  module Work
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

    end
  end
end

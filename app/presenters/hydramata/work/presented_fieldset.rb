require 'hydramata/work/base_presenter'

module Hydramata
  module Work
    class PresentedFieldset < BasePresenter
      extend Forwardable
      attr_reader :entity
      def initialize(collaborators = {})
        fieldset = collaborators.fetch(:fieldset)
        @entity = collaborators.fetch(:entity)
        super(fieldset, collaborators)
      end

      def work_type
        entity.work_type
      end

      private

      def default_presentation_context
        entity.respond_to?(:presentation_context) ? entity.presentation_context : 'show'
      end

      def view_path_slug_for_object
        'fieldsets'
      end

    end
  end
end

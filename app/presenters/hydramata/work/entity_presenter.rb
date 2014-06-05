require 'hydramata/work/conversions'
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

      def default_presented_fieldset_builder
        ->(*args) { PresentedFieldsets(*args) }
      end
    end
  end
end

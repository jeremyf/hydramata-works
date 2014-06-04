require 'hydramata/work/conversions'

module Hydramata
  module Work
    class PresentedEntity
      include Conversions
      extend Forwardable

      attr_reader :entity, :presentation_structure, :presented_fieldset_builder
      def initialize(collaborators = {})
        self.entity = collaborators.fetch(:entity)
        @presentation_structure = collaborators.fetch(:presentation_structure)
        @presented_fieldset_builder = collaborators.fetch(:presented_fieldset_builder) { default_presented_fieldset_builder }
      end

      def fieldsets
        @fieldsets ||= presented_fieldset_builder.call(entity: entity, presentation_structure: presentation_structure)
      end

      def_delegator :entity, :entity_type

      protected

      # Adding a setter as I want to make sure that the collaborating entity
      # is "well-formed".
      def entity=(entity)
        @entity = entity
      end

      def default_presented_fieldset_builder
        lambda { |*args| PresentedFieldsets(*args) }
      end
    end
  end
end

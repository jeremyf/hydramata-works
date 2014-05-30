module Hydramata
  module Work
    class PresentedEntity
      extend Forwardable

      attr_reader :entity, :presentation_structure
      def initialize(collaborators = {})
        self.entity = collaborators.fetch(:entity)
        @presentation_structure = collaborators.fetch(:presentation_structure)
      end

      def each_fieldset_with_properties
        @presentation_structure.fieldsets.each do |fieldset, predicates|
          properties = {}
          predicates.each_with_object(properties) do |predicate, mem|
            mem[predicate] = entity.property(predicate)
            mem
          end
          yield(fieldset, properties)
        end
      end

      def_delegator :entity, :entity_type

      protected

      # Adding a setter as I want to make sure that the collaborating entity
      # is "well-formed".
      def entity=(entity)
        @entity = entity
      end
    end
  end
end
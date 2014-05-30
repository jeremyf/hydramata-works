module Hydramata
  module Work
    class PresentedEntity
      attr_reader :entity, :presentation_structure
      def initialize(collaborators = {})
        @entity = collaborators.fetch(:entity)
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
    end
  end
end
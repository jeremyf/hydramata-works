require 'hydramata/work/property'

module Hydramata
  module Work
    module Conversions
      private
      def Property(input)
        if input.instance_of?(Property)
          input
        else
          Property.new(input)
        end
      end

      def PresentedFieldsets(collaborators)
        entity = collaborators.fetch(:entity)
        presentation_structure = collaborators.fetch(:presentation_structure)
        presentation_structure.fieldsets.each_with_object([]) do |(fieldset_name, predicates), collector|
          fieldset = PropertySet.new(name: fieldset_name)
          collector << entity.properties.subset(predicates, fieldset)
        end
      end
    end
  end
end

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
          property_builder = lambda {|pr| PropertyPresenter.new(property: pr, fieldset: fieldset, entity: entity) }
          entity.properties.subset(predicates, fieldset, property_builder)
          presented_fieldset = FieldsetPresenter.new(entity: entity, fieldset: fieldset)
          collector << presented_fieldset
        end
      end
    end
  end
end

require 'hydramata/work/conversions/property_set'
require 'hydramata/work/conversions/predicate_set'
require 'hydramata/work/fieldset_presenter'
module Hydramata
  module Work
    module Conversions
      def PresentedFieldsets(collaborators)
        # @TODO - This could be packaged up into a tidier location.
        # The collaboration with an entity's PropertySet#subset is convoluted.
        # I also don't know if I need.
        entity = collaborators.fetch(:entity)
        presentation_structure = collaborators.fetch(:presentation_structure)
        presentation_structure.fieldsets.each_with_object([]) do |predicate_set, collector|
          predicate_set = PredicateSet(predicate_set)
          predicates = predicate_set.predicates
          property_set = PropertySet(predicate_set)
          property_builder = ->(property) {
            require 'hydramata/work/property_presenter'
            PropertyPresenter.new(property: property, fieldset: property_set, entity: entity)
          }
          entity.properties.subset(predicates, property_set, property_builder)
          presented_fieldset = FieldsetPresenter.new(entity: entity, fieldset: property_set)
          collector << presented_fieldset
        end
      end
    end
  end
end

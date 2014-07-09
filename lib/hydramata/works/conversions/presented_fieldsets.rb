require 'hydramata/works/conversions/property_set'
require 'hydramata/works/conversions/predicate_set'
require 'hydramata/works/fieldset_presenter'
module Hydramata
  module Works
    module Conversions
      private
      def PresentedFieldsets(collaborators)
        # @TODO - This could be packaged up into a tidier location.
        # The collaboration with an work's PropertySet#subset is convoluted.
        # I also don't know if I need.
        work = collaborators.fetch(:work)
        presentation_structure = collaborators.fetch(:presentation_structure)
        presentation_structure.fieldsets.each_with_object([]) do |predicate_set, collector|
          predicate_set = PredicateSet(predicate_set)
          predicates = predicate_set.predicates
          property_set = PropertySet(predicate_set)
          property_builder = ->(property) {
            require 'hydramata/works/property_presenter'
            PropertyPresenter.new(property: property, fieldset: property_set, work: work)
          }
          work.properties.subset(predicates, property_set, property_builder)
          presented_fieldset = FieldsetPresenter.new(work: work, fieldset: property_set)
          collector << presented_fieldset
        end
      end
    end
  end
end

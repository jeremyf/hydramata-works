module Hydramata
  module Work
    # Taking a que from Avdi Grimm's "Confident Ruby", the Conversion module
    # is responsible for coercing the inputs to another format.
    #
    # This is somewhat experimental, though analogous to the Array() method in
    # base ruby.
    module Conversions
      class ConversionError < RuntimeError
        def initialize(class_name, input)
          super("Could not convert #{input.inspect} to #{class_name}")
        end
      end

      private

      def Value(input)
        require 'hydramata/work/value'
        case input
        when Value then input
        when Hash then Value.new(input)
        when String, Symbol then Value.new(value: input)
        else
          raise ConversionError.new(:Value, input)
        end
      end

      def Predicate(input)
        require 'hydramata/work/predicates'
        case input
        when Predicate then input
        when String, Symbol then Predicates.find(input)
        when Hash then Predicates.find(input.fetch(:identity), input)
        else
          raise ConversionError.new(:Predicate, input)
        end
      end

      def WorkType(input)
        require 'hydramata/work/work_types'
        case input
        when Predicate then input
        when String, Symbol then WorkTypes.find(input)
        when Hash then WorkTypes.find(input.fetch(:identity), input)
        else
          raise ConversionError.new(:WorkType, input)
        end
      end

      def Property(input)
        require 'hydramata/work/property'

        if input.instance_of?(Property)
          input
        else
          Property.new(input)
        end
      end

      def PresentedFieldsets(collaborators)
        # @TODO - This could be packaged up into a tidier location.
        # The collaboration with an entity's PropertySet#subset is convoluted.
        # I also don't know if I need.
        entity = collaborators.fetch(:entity)
        presentation_structure = collaborators.fetch(:presentation_structure)
        presentation_structure.fieldsets.each_with_object([]) do |(fieldset_name, predicates), collector|
          fieldset = PropertySet.new(name: fieldset_name)
          property_builder = ->(pr) { PropertyPresenter.new(property: pr, fieldset: fieldset, entity: entity) }
          entity.properties.subset(predicates, fieldset, property_builder)
          presented_fieldset = FieldsetPresenter.new(entity: entity, fieldset: fieldset)
          collector << presented_fieldset
        end
      end
    end
  end
end

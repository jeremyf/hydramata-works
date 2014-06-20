require 'hydramata/work/conversions/exceptions'
require 'hydramata/work/conversions/predicate_set'
require 'hydramata/work/predicate_set'
require 'hydramata/work/property_set'

module Hydramata
  module Work
    module Conversions
      private
      def PropertySet(input)
        return input.to_property_set if input.respond_to?(:to_property_set)

        case input
        when PropertySet then input
        when PredicateSet then PropertySet.new(predicate_set: input)
        else
          predicate_set = PredicateSet(input)
          PropertySet(predicate_set)
        end
      end
    end
  end
end

require 'hydramata/works/conversions/exceptions'
require 'hydramata/works/conversions/predicate_set'
require 'hydramata/works/predicate_set'
require 'hydramata/works/property_set'

module Hydramata
  module Works
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

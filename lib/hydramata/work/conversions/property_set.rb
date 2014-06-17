require 'hydramata/work/conversions/exceptions'
require 'hydramata/work/conversions/predicate_set'
require 'hydramata/work/predicate_sets/storage'
require 'hydramata/work/predicate_set'
require 'hydramata/work/property_set'

module Hydramata
  module Work
    module Conversions
      private
      def PropertySet(input)

        case input
        when PropertySet then input
        when PredicateSet then PropertySet.new(name: input.identity)
        else
          predicate_set = PredicateSet(input)
          PropertySet(predicate_set)
        end
      end
    end
  end
end

require 'hydramata/work/conversions/exceptions'

module Hydramata
  module Work
    module Conversions
      private
      def PredicateSet(input)
        require 'hydramata/work/predicate_sets/storage'
        require 'hydramata/work/predicate_set'

        case input
        when PredicateSet then input
        when PredicateSets::Storage then PredicateSet.new(input.predicate_set_attributes)
        when Hash then PredicateSet.new(input)
        when Array then
          if input.size == 2
            PredicateSet.new(identity: input[0], predicates: input[1])
          else
            raise ConversionError.new(:PredicateSet, input)
          end
        else
          raise ConversionError.new(:PredicateSet, input)
        end
      end
    end
  end
end

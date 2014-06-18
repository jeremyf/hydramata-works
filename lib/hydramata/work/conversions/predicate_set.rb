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
        when String then PredicateSet.new(identity: input)
        when Array then
          case input.size
          when 0 then raise ConversionError.new(:PredicateSet, input)
          when 1 then PredicateSet.new(identity: input[0])
          when 2 then PredicateSet.new(identity: input[0], predicates: input[1])
          else
            PredicateSet.new(identity: input[0], predicates: input[1..-1])
          end
        else
          raise ConversionError.new(:PredicateSet, input)
        end
      end
    end
  end
end

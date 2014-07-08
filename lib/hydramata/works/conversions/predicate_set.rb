require 'hydramata/works/conversions/exceptions'
require 'hydramata/works/predicate_set'

module Hydramata
  module Works
    module Conversions
      private
      def PredicateSet(input)
        return input.to_predicate_set if input.respond_to?(:to_predicate_set)
        case input
        when PredicateSet then input
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

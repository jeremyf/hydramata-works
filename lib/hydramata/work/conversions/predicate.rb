require 'hydramata/work/conversions/exceptions'
require 'hydramata/work/predicate'
require 'hydramata/work/predicates'

module Hydramata
  module Work
    module Conversions
      private
      def Predicate(input)
        case input
        when Predicate then input
        when Predicates::Storage then Predicate.new(input.attributes)
        when String, Symbol then Predicates.find(input)
        when Hash then Predicates.find(input.fetch(:identity), input)
        else
          raise ConversionError.new(:Predicate, input)
        end
      end
    end
  end
end

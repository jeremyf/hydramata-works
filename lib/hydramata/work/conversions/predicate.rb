require 'hydramata/work/conversions/exceptions'

module Hydramata
  module Work
    module Conversions
      private
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
    end
  end
end

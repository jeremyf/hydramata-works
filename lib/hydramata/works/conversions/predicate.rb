require 'hydramata/works/conversions/exceptions'
require 'hydramata/works/predicate'
require 'hydramata/works/predicates'

module Hydramata
  module Works
    module Conversions
      private
      def Predicate(input)
        return input.to_predicate if input.respond_to?(:to_predicate)

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

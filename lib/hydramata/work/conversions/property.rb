require 'hydramata/work/conversions/exceptions'
require 'hydramata/work/property'
require 'hydramata/work/conversions/predicate'
require 'hydramata/work/predicate'

module Hydramata
  module Work
    module Conversions
      private
      def Property(input)

        case input
        when Property then input
        when Predicate then Property.new(predicate: input)
        when Hash then Property.new(input)
        else
          predicate = Predicate(input)
          Property.new(predicate: predicate)
        end
      end
    end
  end
end

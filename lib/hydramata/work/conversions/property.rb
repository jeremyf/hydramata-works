require 'hydramata/work/conversions/exceptions'
require 'hydramata/work/property'
require 'hydramata/work/conversions/predicate'
require 'hydramata/work/predicate'

module Hydramata
  module Work
    module Conversions
      private
      def Property(*args)
        if args.size == 0
          raise ConversionError.new(:Property, args)
        else
          input = args.first
          property =
          case input
          when Property then input
          when Predicate then Property.new(predicate: input)
          when Hash then Property.new(input)
          else
            predicate = Predicate(input)
            Property.new(predicate: predicate)
          end
          values = args[1..-1]
          property << values
          property
        end
      end
    end
  end
end

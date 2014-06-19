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
          values = args[1..-1]
          case input
          when Property then input << values
          when Predicate then Property.new(predicate: input, values: values)
          when Hash then Property.new(input) << values
          else
            predicate = Predicate(input)
            Property.new(predicate: predicate, values: values)
          end
        end
      end
    end
  end
end

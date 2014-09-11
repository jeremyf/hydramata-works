require 'hydramata/works/conversions/exceptions'
require 'hydramata/works/property'
require 'hydramata/works/conversions/predicate'
require 'hydramata/works/predicate'

module Hydramata
  module Works
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
          property << values if values.size > 0
          property
        end
      end
    end
  end
end

require 'hydramata/work/conversions/exceptions'

module Hydramata
  module Work
    module Conversions
      private
      def Value(input)
        require 'hydramata/work/value'
        case input
        when Value then input
        when Hash then Value.new(input)
        when String, Symbol then Value.new(value: input)
        else
          raise ConversionError.new(:Value, input)
        end
      end
    end
  end
end

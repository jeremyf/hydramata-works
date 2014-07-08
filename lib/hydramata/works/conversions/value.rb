require 'hydramata/works/conversions/exceptions'
require 'hydramata/works/value'

module Hydramata
  module Works
    module Conversions
      private
      def Value(input)
        return input.to_value if input.respond_to?(:to_value)
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

require 'hydramata/works/conversions/exceptions'

module Hydramata
  module Works
    module Conversions

      private
      def ViewPathFragment(input)
        return input.to_view_path_fragment.to_s.downcase.gsub(/\W+/, '_') if input.respond_to?(:to_view_path_fragment)
        case input
        when String, Symbol then input.to_s.downcase.gsub(/\W+/, '_')
        when Hash then
          value = input[:to_view_path_fragment] || input['to_view_path_fragment']
          ViewPathFragment(value)
        else
          fail ConversionError.new(:ViewPathFragment, input)
        end
      end
    end
  end
end

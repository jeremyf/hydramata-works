require 'hydramata/works/conversions/exceptions'

module Hydramata
  module Works
    module Conversions
      private
      def TranslationKeyFragment(input)
        return input.to_translation_key_fragment.to_s.downcase.gsub(/\W+/, '_') if input.respond_to?(:to_translation_key_fragment)
        case input
        when String, Symbol then input.to_s.downcase.gsub(/\W+/, '_')
        when Hash then
          value = input[:to_translation_key_fragment] || input['to_translation_key_fragment']
          TranslationKeyFragment(value)
        else
          raise ConversionError.new(:TranslationKeyFragment, input)
        end
      end
    end
  end
end

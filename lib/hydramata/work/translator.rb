require 'active_support/core_ext/array/wrap'

module Hydramata
  module Work
    class Translator
      attr_reader :base_scope, :translation_service, :translation_service_error
      def initialize(options = {})
        self.base_scope = options.fetch(:base_scope) { default_base_scope }
        @translation_service = options.fetch(:translation_service) { default_translation_service }
        @translation_service_error = options.fetch(:translation_service_error) { default_translation_service_error }
      end

      def translate(key, specific_scopes)
        translated_value = nil
        translate_key_for_specific_scopes(key, specific_scopes) || translate_key_for_general_case(key)
      end

      private

      def translate_key_for_specific_scopes(key, scopes)
        options = { raise: true }
        returning_value = nil
        Array.wrap(scopes).each do |scope|
          begin
            options[:scope] = base_scope + Array.wrap(scope)
            returning_value = translation_service.translate(key, options)
            break
          rescue *translation_service_error
            next
          end
        end
        returning_value
      end

      def translate_key_for_general_case(key)
        translation_service.translate(key, scope: base_scope)
      end

      def base_scope=(values)
        @base_scope = Array.wrap(values)
      end

      def default_base_scope
        ['hydramata', 'work']
      end

      def default_translation_service_error
        require 'i18n/exceptions'
        I18n::ArgumentError
      end

      def default_translation_service
        require 'i18n'
        I18n
      end
    end
  end
end

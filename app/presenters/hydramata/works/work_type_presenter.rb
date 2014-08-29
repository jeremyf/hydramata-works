require 'hydramata/works/base_presenter'
require 'hydramata/works/conversions/translation_key_fragment'

module Hydramata
  module Works
    class WorkTypePresenter < SimpleDelegator
      include Conversions
      def initialize(object, collaborators = {})
        __setobj__(object)
        @translator = collaborators.fetch(:translator) { default_translator }
        @translation_scopes = collaborators.fetch(:translation_scopes) { default_translation_scopes }
      end

      def description(options = {})
        translator.translate('description', options.reverse_merge(scopes: translation_scopes))
      end

      def name(options = {})
        translator.translate('name', options.reverse_merge(scopes: translation_scopes, default: __getobj__.name))
      end

      alias_method :to_s, :name

      def inspect
        format('#<%s:%#0x presenting=%s>', self.class, __id__, __getobj__.inspect)
      end

      def instance_of?(klass)
        super || __getobj__.instance_of?(klass)
      end

      private
      attr_reader :translator, :translation_scopes
      private :translator, :translation_scopes
      def default_translation_scopes
        [
          ['work_types', TranslationKeyFragment(self)]
        ]
      end

      def default_translator
        require 'hydramata/core'
        Hydramata.configuration.translator
      end
    end
  end
end

require 'hydramata/works/conversions/translation_key_fragment'

module Hydramata
  module Works
    class ActionPresenter
      include Conversions
      attr_reader :action_name, :work

      def initialize(collaborators = {})
        @action_name = collaborators.fetch(:action_name)
        @work = collaborators.fetch(:work)
        @translator = collaborators.fetch(:translator) { default_translator }
      end

      def render(options = {})
        template = options.fetch(:template)
        template.submit_tag(action_name)
      end

      def translate(key, options = {})
        translator.t("actions.#{key}", options.reverse_merge(scopes: translation_scopes, default: key))
      end
      alias_method :t, :translate

      private
      attr_reader :translator
      private :translator

      def default_translator
        require 'hydramata/core/translator'
        Core::Translator.new(base_scope: ['hydramata', 'core'])
      end

      def translation_scopes
        [
          ['works', TranslationKeyFragment(work)]
        ]
      end
    end
  end
end

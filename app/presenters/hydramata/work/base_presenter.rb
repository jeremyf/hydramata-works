require 'delegate'
module Hydramata
  module Work
    class BasePresenter < SimpleDelegator
      attr_reader :presentation_context, :translator
      def initialize(object, collaborators = {})
        __setobj__(object)
        @presentation_context = collaborators.fetch(:presentation_context) { default_presentation_context }
        @translator = collaborators.fetch(:translator) { default_translator }
      end

      def render(options = {})
        template = options.fetch(:template)
        rendering_options = { partial: partial_name, object: self }
        rendering_options[:locals] = options[:locals] if options.key?(:locals)
        template.render(rendering_options)
      end

      def inspect
        format('#<%s:%#0x presenting=%s>', self.class, __id__, __getobj__.inspect)
      end

      def instance_of?(klass)
        super || __getobj__.instance_of?(klass)
      end

      def dom_class
        __getobj__.name.to_s.downcase.gsub(/[\W_]+/, '-')
      end

      def translate(key)
        translator.t(translation_scope_for(key), default: default_translation_for(key))
      end
      alias_method :t, :translate

      private

      def partial_name
        File.join('hydramata/work', view_path_slug_for_object, presentation_context.to_s)
      end

      def default_presentation_context
        'show'
      end

      def view_path_slug_for_object
        'base'
      end

      def default_translation_for(key)
        proc { send(key).to_s }
      end

      def translation_scope_for(key)
        "hydramata.work.#{view_path_slug_for_object}.#{key}"
      end

      def default_translator
        require 'i18n'
        I18n
      end
    end
  end
end

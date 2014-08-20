require 'delegate'
require 'active_support/core_ext/array/wrap'
require 'hydramata/works/conversions/translation_key_fragment'

module Hydramata
  module Works
    # Responsible for coordinating the rendering of an in-memory data structure
    # object to an output buffer.
    class BasePresenter < SimpleDelegator
      include Conversions
      attr_reader :presentation_context, :translator, :partial_prefixes, :template_missing_error, :translation_scopes
      def initialize(object, collaborators = {})
        __setobj__(object)
        @presentation_context = collaborators.fetch(:presentation_context) { default_presentation_context }
        @translator = collaborators.fetch(:translator) { default_translator }
        @partial_prefixes = collaborators.fetch(:partial_prefixes) { default_partial_prefixes }
        @translation_scopes = collaborators.fetch(:translation_scopes) { default_translation_scopes }
        @template_missing_error = collaborators.fetch(:template_missing_exception) { default_template_missing_exception }
        @dom_attributes_builder = collaborators.fetch(:dom_attributes_builder) { default_dom_attributes_builder }
      end

      def render(options = {})
        template = options.fetch(:template)
        rendering_options = rendering_options_for(options)
        render_with_diminishing_specificity(template, rendering_options)
      end

      def inspect
        format('#<%s:%#0x presenting=%s>', self.class, __id__, __getobj__.inspect)
      end

      def instance_of?(klass)
        super || __getobj__.instance_of?(klass)
      end

      def dom_class(options = {})
        prefix = options.fetch(:prefix, nil)
        suffix = options.fetch(:suffix, nil)
        [prefix, base_dom_class, suffix].compact.join('-')
      end

      def translate(key)
        translator.t(key, scopes: translation_scopes, default: default_translation_for(key))
      end
      alias_method :t, :translate

      def name
        __getobj__.respond_to?(:name) ? __getobj__.name : __getobj__.name_for_application_usage
      end

      def to_presenter
        self
      end

      def container_content_tag_attributes(options = {})
        dom_attributes_builder.call(self, options, default_dom_attributes)
      end

      def presenter_dom_class
        self.class.to_s.split('::').last.sub(/presenter\Z/i,'').downcase
      end

      private

      attr_reader :dom_attributes_builder
      def default_dom_attributes_builder
        require 'hydramata/works/dom_attributes_builder'
        DomAttributesBuilder
      end

      def default_dom_attributes
        {}
      end

      def base_dom_class
        name.to_s.downcase.gsub(/[\W_]+/, '-')
      end

      def render_with_diminishing_specificity(template, rendering_options)
        render_with_prefixes(template, rendering_options) || render_without_prefixes(template, rendering_options)
      end

      def render_with_prefixes(template, rendering_options)
        rendered = nil
        partial_prefixes.each do |partial_prefix|
          begin
            rendered = template.render(rendering_options.merge(partial: partial_name(partial_prefix)))
            break
            # By using the splat operator I am allowing multiple exceptions to
            # be caught and pass to the next rendering context.
          rescue *template_missing_error
            next
          end
        end
        rendered
      end

      def render_without_prefixes(template, rendering_options)
        template.render(rendering_options.merge(partial: partial_name))
      end

      def default_partial_prefixes
        []
      end

      def default_translation_scopes
        []
      end

      def rendering_options_for(options = {})
        returning_options = { object: self }
        returning_options[:locals] = options[:locals] if options.key?(:locals)
        returning_options
      end

      def partial_name(*current_partial_prefixes)
        partial_prefix = Array.wrap(current_partial_prefixes).join("/")
        File.join('hydramata/works', view_path_slug_for_object, partial_prefix , presentation_context.to_s)
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

      def default_translator
        require 'hydramata/translations/translator'
        Translations::Translator
      end

      # Because actually testing this is somewhat of a nightmare given the
      # 5+ parameters that are required when instantiating this exception.
      def default_template_missing_exception
        require 'action_view/template/error'
        ActionView::MissingTemplate
      end
    end
  end
end

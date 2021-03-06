require 'delegate'
require 'active_support/core_ext/array/wrap'
require 'hydramata/works/conversions/translation_key_fragment'
require 'hydramata/works/conversions/view_path_fragment'

module Hydramata
  module Works
    # Responsible for coordinating the rendering of an in-memory data structure
    # object to an output buffer.
    class BasePresenter < SimpleDelegator
      include Conversions
      attr_reader :presentation_context, :translator, :partial_prefixes, :translation_scopes, :renderer
      def initialize(object, collaborators = {})
        __setobj__(object)
        @presentation_context = collaborators.fetch(:presentation_context) { default_presentation_context }
        @partial_prefixes = collaborators.fetch(:partial_prefixes) { default_partial_prefixes }
        @translator = collaborators.fetch(:translator) { default_translator }
        @translation_scopes = collaborators.fetch(:translation_scopes) { default_translation_scopes }
        @dom_attributes_builder = collaborators.fetch(:dom_attributes_builder) { default_dom_attributes_builder }
        @renderer = collaborators.fetch(:renderer) { default_renderer }
      end

      def render(template, options = {})
        renderer.call(template, options)
      end

      def translate(key, options = {})
        translator.t(key, { scopes: translation_scopes }.merge(options))
      end
      alias_method :t, :translate

      def with_text_for(key, options = {})
        translation = translate(key, { raise: true }.merge(options))
        yield(translation) if block_given?
        translation
      rescue StandardError
        :no_translation
      end

      def label(options = {})
        translator.t(:label, { scopes: translation_scopes, default: name.to_s }.merge(options))
      end

      def inspect
        format('#<%s:%#0x presenting=%s>', self.class, __id__, __getobj__.inspect)
      end

      def instance_of?(klass)
        super || __getobj__.instance_of?(klass)
      end

      def dom_class(prefix: nil, suffix: nil)
        [prefix, base_dom_class, suffix].compact.join('-')
      end

      def name
        __getobj__.respond_to?(:name) ? __getobj__.name : __getobj__.name_for_application_usage
      end

      def to_presenter
        self
      end

      def container_content_tag_attributes(options = {})
        dom_attributes_builder.call(self, options, default_dom_attributes)
      end

      def presenter_dom_class(prefix: nil, suffix: nil)
        [prefix, base_presenter_dom_class, suffix].compact.join('-')
      end

      def base_presenter_dom_class
        self.class.to_s.split('::').last.sub(/presenter\Z/i,'').downcase
      end

      def view_path_slug_for_object
        raise NotImplementedError.new("You must implmenent #{self.class}#view_path_slug_for_object")
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

      def default_partial_prefixes
        []
      end

      def default_translation_scopes
        []
      end

      def default_presentation_context
        :show
      end

      def default_translator
        require 'hydramata/core'
        Hydramata.configuration.translator
      end

      def default_renderer
        require 'hydramata/works/work_template_renderer'
        WorkTemplateRenderer.new(self)
      end

      def require(*args)
        # Because the value object may decide to implement #require (I'm glaring
        # at you ActionController::Parameters, and your #require method).
        ::Kernel.require(*args)
      end
    end
  end
end

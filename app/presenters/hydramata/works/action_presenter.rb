require 'hydramata/works/conversions/translation_key_fragment'
require 'active_support/core_ext/array/wrap'

module Hydramata
  module Works
    # Responsible for rendering different kinds of actions:
    # :a-tags:
    # :submit-tags:
    class ActionPresenter

      include Conversions
      attr_reader :name, :context

      def initialize(collaborators = {})
        @name = collaborators.fetch(:name)
        @context = collaborators.fetch(:context)
      end

      def render(template, options = {})
        send("render_#{type}", template, options)
      end

      private

      def label
        context.translate("actions.#{name}.label", default: 'Save changes')
      end

      def dom_class
        context.translate("actions.#{name}.dom_class", default: "named-action action-#{name}")
      end

      def type
        context.translate("actions.#{name}.type", default: 'link')
      end

      def url
        context.translate("actions.#{name}.url", raise: true, to_param: context.to_param)
      end

      def render_submit(template, options)
        options[:class] = Array.wrap(options[:class])
        options[:class] << dom_class
        template.submit_tag(label, options)
      end

      def render_link(template, options)
        options[:href] ||= url
        options[:class] = Array.wrap(options[:class])
        options[:class] << dom_class
        template.content_tag('a', label, options)
      end

    end
  end
end

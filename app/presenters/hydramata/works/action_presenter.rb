require 'hydramata/works/conversions/translation_key_fragment'

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

      def render(options = {})
        send("render_#{type}", options)
      end

      private

      def label
        context.translate("actions.#{name}.label", default: 'Save changes')
      end

      def type
        context.translate("actions.#{name}.type", default: 'link')
      end

      def url
        context.translate("actions.#{name}.url", raise: true, to_param: context.to_param)
      end

      def render_submit(options)
        template = options.fetch(:template)
        action_options = options.fetch(:action_options, {})
        template.submit_tag(label, action_options)
      end

      def render_link(options)
        template = options.fetch(:template)
        action_options = options.fetch(:action_options, {})
        action_options[:href] ||= url
        template.content_tag('a', label, action_options)
      end

    end
  end
end

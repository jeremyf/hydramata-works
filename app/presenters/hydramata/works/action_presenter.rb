require 'hydramata/works/conversions/translation_key_fragment'

module Hydramata
  module Works
    class ActionPresenter

      include Conversions
      attr_reader :name, :context

      def initialize(collaborators = {})
        @name = collaborators.fetch(:name)
        @context = collaborators.fetch(:context)
      end

      def render(options = {})
        template = options.fetch(:template)
        action_options = options.fetch(:action_options, {})
        template.submit_tag(value, action_options)
      end

      def value
        context.translate("actions.#{name}.value", default: 'Save changes')
      end

    end
  end
end

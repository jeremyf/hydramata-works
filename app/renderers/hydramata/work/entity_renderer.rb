module Hydramata
  module Work
    class EntityRenderer
      attr_reader :context, :template, :format, :presented_entity, :template_name_prefix
      def initialize(options = {})
        @format = options.fetch(:format) { default_format }
        @template = options.fetch(:template) { default_template }
        @template_name_prefix = options.fetch(:template_name_prefix) { default_template_name_prefix }

        @context = options.fetch(:context)
        @presented_entity = PresentedEntity.new(options)
      end

      def render
        template.render(file: template_name, locals: { context.to_sym => presented_entity })
      end

      private

      def template_name
        File.join(template_name_prefix, context.to_s)
      end

      def default_template_name_prefix
        'hydramata/work/entities'
      end

      def default_format
        :html
      end

      def default_template
        view_container = ActionController::Base
        ActionView::Base.new(view_container.view_paths, {}, view_container.new, [format])
      end

      def view_container=(object)
        @view_container = object
      end
    end
  end
end
require 'hydramata/work/presented_entity'
module Hydramata
  module Work
    class EntityRenderer
      attr_reader :context, :template, :format, :presented_entity, :template_name_prefix, :view_path
      def initialize(options = {})
        @format = options.fetch(:format) { default_format }
        @view_path = options.fetch(:view_path) { default_view_path }
        @template_name_prefix = options.fetch(:template_name_prefix) { default_template_name_prefix }

        @template = options.fetch(:template) { default_template }
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
        view_container = ActionController::Base.new
        # This appears to resolve the path relative to the Hydramata::Work
        # Engine's paths['app/views']. I don't know if this will continue to
        # work that way.
        view_container.prepend_view_path(view_path) if view_path.present?
        ActionView::Base.new(view_container.view_paths, {}, view_container, [format])
      end

      def view_container=(object)
        @view_container = object
      end

      def default_view_path
        nil
      end
    end
  end
end
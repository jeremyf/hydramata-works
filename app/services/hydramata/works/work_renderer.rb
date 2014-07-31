module Hydramata
  module Works
    # For some reason if you want to render the object outside of the context
    # of a controller, this provides the wrapper.
    class WorkRenderer
      attr_reader :template, :format, :work, :view_path
      def initialize(options = {})
        @work = options.fetch(:work)
        @format = options.fetch(:format) { default_format }
        @view_path = options.fetch(:view_path) { default_view_path }
        @template = options.fetch(:template) { default_template }
      end

      def render
        work.render(template: template)
      end

      private

      def default_format
        :html
      end

      def default_template
        view_container = ActionController::Base.new
        # This appears to resolve the path relative to the Hydramata::Works
        # Engine's paths['app/views']. I don't know if this will continue to
        # work that way.
        view_container.prepend_view_path(view_path) if view_path.present?
        view = ActionView::Base.new(view_container.view_paths, {}, view_container, [format])

        # Required if rendering a form. Defaults to false as this is a
        # convenience object.
        def view.protect_against_forgery?
          false
        end
        view
      end

      def default_view_path
        nil
      end
    end
  end
end

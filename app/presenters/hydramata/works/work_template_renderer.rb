require 'delegate'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/array/wrap'

module Hydramata
  module Works
    class WorkTemplateRenderer

      attr_reader :context, :template_missing_exception
      def initialize(context, collaborators = {})
        self.context = context
        @template_missing_exception = collaborators.fetch(:template_missing_exception) { default_template_missing_exception }
      end

      private :template_missing_exception

      def call(options = {}, &block)
        template = options.fetch(:template)
        rendering_options = rendering_options_for(options)
        begin
          render_with_diminishing_specificity(template, rendering_options)
        rescue *template_missing_exception => e
          STDOUT.puts(e) if ENV['DEBUG']
          if block_given?
            yield
          else
            raise e
          end
        end
      end

      delegate :partial_prefixes, :view_path_slug_for_object, :presentation_context, to: :context

      protected

      def context=(object)
        @context = object
      end

      private

      def rendering_options_for(options = {})
        returning_options = { object: context }
        returning_options[:locals] = options[:locals] if options.key?(:locals)
        returning_options
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
          rescue *template_missing_exception => e
            STDOUT.puts(e) if ENV['DEBUG']
            next
          end
        end
        rendered
      end

      def render_without_prefixes(template, rendering_options)
        template.render(rendering_options.merge(partial: partial_name))
      end

      # Because actually testing this is somewhat of a nightmare given the
      # 5+ parameters that are required when instantiating this exception.
      def default_template_missing_exception
        require 'action_view/template/error'
        ActionView::MissingTemplate
      end

      def partial_name(*current_partial_prefixes)
        partial_prefix = Array.wrap(current_partial_prefixes).join("/")
        File.join('hydramata/works', view_path_slug_for_object, partial_prefix , presentation_context.to_s)
      end

    end
  end
end

require 'delegate'
module Hydramata
  module Work
    # Responsible for coordinating the rendering of an in-memory data structure
    # object to an output buffer.
    class BasePresenter < SimpleDelegator
      attr_reader :presentation_context, :translator, :view_chain, :template_missing_error
      def initialize(object, collaborators = {})
        __setobj__(object)
        @presentation_context = collaborators.fetch(:presentation_context) { default_presentation_context }
        @translator = collaborators.fetch(:translator) { default_translator }
        @view_chain = collaborators.fetch(:view_chain) { default_view_chain }
        @template_missing_error = collaborators.fetch(:template_missing_exception) { default_template_missing_exception }
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

      def dom_class
        __getobj__.name.to_s.downcase.gsub(/[\W_]+/, '-')
      end

      def translate(key)
        translator.t(translation_scope_for(key), default: default_translation_for(key))
      end
      alias_method :t, :translate

      private

      def render_with_diminishing_specificity(template, rendering_options)
        view_depth = view_chain.size
        (0...view_depth).each do |index|
          begin
            partial_prefix = view_chain[0..(view_chain.size - index - 1)]
            rendering_options[:partial] = partial_name(partial_prefix)
            template.render(rendering_options)
          # By using the splat operator I am allowing multiple exceptions to
          # be caught and pass to the next rendering context.
          rescue *template_missing_error
            next
          end
        end

        # Our last resort! If this fails, we want it to bubble up.
        rendering_options[:partial] = partial_name
        template.render(rendering_options)
      end

      def default_view_chain
        []
      end

      def rendering_options_for(options = {})
        returning_options = { object: self }
        returning_options[:locals] = options[:locals] if options.key?(:locals)
        returning_options
      end

      def partial_name(current_view_chain = [])
        File.join('hydramata/work', view_path_slug_for_object, current_view_chain.join("/"), presentation_context.to_s)
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

      # Because actually testing this is somewhat of a nightmare given the
      # 5+ parameters that are required when instantiating this exception.
      def default_template_missing_exception
        require 'action_view/template/error'
        ActionView::MissingTemplate
      end
    end
  end
end

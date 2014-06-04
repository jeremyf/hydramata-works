module Hydramata
  module Work
    class BasePresenter < SimpleDelegator

      attr_reader :presentation_context
      def initialize(object, collaborators = {})
        __setobj__(object)
        @presentation_context = collaborators.fetch(:presentation_context) { default_presentation_context }
      end

      def render(options = {})
        template = options.fetch(:template)
        template.render(partial: partial_name, object: self)
      end

      def instance_of?(klass)
        super || __getobj__.instance_of?(klass)
      end

      def dom_class
        __getobj__.name.to_s.downcase.gsub(/[\W_]+/, '-')
      end

      private

      def partial_name
        File.join('hydramata/work', view_path_slug_for_object, presentation_context.to_s)
      end

      def default_presentation_context
        'show'
      end

      def view_path_slug_for_object
        fail NotImplementedError, ("Define #{self.class}#view_path_slug_for_object.")
      end

    end
  end
end

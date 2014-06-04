require 'delegate'
module Hydramata
  module Work
    class PresentedProperty < SimpleDelegator

      def initialize(property)
        __setobj__(property)
      end

      def render(options = {})
        template = options.fetch(:template)
        template.render(partial: template_name, object: self)
      end

      def instance_of?(klass)
        super || __getobj__.instance_of?(klass)
      end

      private

      def template_name
        File.join(template_name_prefix, presentation_context)
      end

      def template_name_prefix
        'hydramata/work/properties'
      end

      def presentation_context
        'show'
      end

    end
  end
end

require 'delegate'
module Hydramata
  module Work
    class PresentedProperty < SimpleDelegator

      def initialize(property)
        __setobj__(property)
      end

      def render(options = {})
        template = options.fetch(:template)
        renderer = options.fetch(:renderer)
        template.render(partial: template_name(renderer.context), object: self)
      end

      def template_name(context)
        File.join(template_name_prefix, context.to_s)
      end

      def template_name_prefix
        'hydramata/work/properties'
      end

      def instance_of?(klass)
        super || __getobj__.instance_of?(klass)
      end
    end
  end
end

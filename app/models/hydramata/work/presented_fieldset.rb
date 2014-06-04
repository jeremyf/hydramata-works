require 'delegate'
module Hydramata
  module Work
    class PresentedFieldset < SimpleDelegator
      extend Forwardable
      attr_reader :entity
      def initialize(collaborators = {})
        @entity = collaborators.fetch(:entity)
        fieldset = collaborators.fetch(:fieldset)
        __setobj__(fieldset)
      end

      def_delegator :entity, :entity_type

      def render(options = {})
        template = options.fetch(:template)
        renderer = options.fetch(:renderer)
        template.render(partial: template_name(renderer.context), object: self, locals: { renderer: renderer } )
      end

      def template_name(context)
        File.join(template_name_prefix, context.to_s)
      end

      def template_name_prefix
        'hydramata/work/fieldsets'
      end

      def instance_of?(klass)
        super || __getobj__.instance_of?(klass)
      end

    end
  end
end

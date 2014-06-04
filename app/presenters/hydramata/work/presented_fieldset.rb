require 'delegate'
module Hydramata
  module Work
    class PresentedFieldset < SimpleDelegator
      extend Forwardable
      attr_reader :entity, :presentation_context
      def initialize(collaborators = {})
        @entity = collaborators.fetch(:entity)
        fieldset = collaborators.fetch(:fieldset)
        @presentation_context = collaborators.fetch(:presentation_context) { default_presentation_context }
        __setobj__(fieldset)
      end

      def_delegator :entity, :work_type

      def render(options = {})
        template = options.fetch(:template)
        template.render(partial: template_name, object: self)
      end

      def instance_of?(klass)
        super || __getobj__.instance_of?(klass)
      end

      private

      def default_presentation_context
        entity.respond_to?(:presentation_context) ? entity.presentation_context : 'show'
      end

      def template_name
        File.join(template_name_prefix, presentation_context.to_s)
      end

      def template_name_prefix
        'hydramata/work/fieldsets'
      end


    end
  end
end

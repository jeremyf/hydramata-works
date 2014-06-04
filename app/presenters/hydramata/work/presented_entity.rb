require 'delegate'
require 'hydramata/work/conversions'

module Hydramata
  module Work
    class PresentedEntity < SimpleDelegator
      include Conversions

      attr_reader :entity, :presentation_structure, :presented_fieldset_builder, :presentation_context
      def initialize(collaborators = {})
        __setobj__(collaborators.fetch(:entity))
        @presentation_structure = collaborators.fetch(:presentation_structure)
        @presented_fieldset_builder = collaborators.fetch(:presented_fieldset_builder) { default_presented_fieldset_builder }
        @presentation_context = collaborators.fetch(:presentation_context) { default_presentation_context }
      end

      def fieldsets
        @fieldsets ||= presented_fieldset_builder.call(entity: self, presentation_structure: presentation_structure)
      end

      def render(options = {})
        template = options.fetch(:template)
        template.render(partial: partial_name, object: self)
      end

      def instance_of?(klass)
        super || __getobj__.instance_of?(klass)
      end

      private

      def partial_name
        File.join(template_name_prefix, presentation_context.to_s)
      end

      def template_name_prefix
        'hydramata/work/entities'
      end

      def default_presented_fieldset_builder
        lambda { |*args| PresentedFieldsets(*args) }
      end

      def default_presentation_context
        'show'
      end
    end
  end
end

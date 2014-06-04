module Hydramata
  module Work
    class PresentedFieldset
      extend Forwardable
      attr_reader :entity, :fieldset
      def initialize(collaborators = {})
        @entity = collaborators.fetch(:entity)
        @fieldset = collaborators.fetch(:fieldset)
      end

      def_delegator :entity, :entity_type
      def_delegator :fieldset, :name

      def render(template)
        template.render(file: template_name, locals: { presented_entity.to_sym => presented_entity })
      end

      def default_template_name_prefix
        'hydramata/work/fieldsets'
      end

    end
  end
end
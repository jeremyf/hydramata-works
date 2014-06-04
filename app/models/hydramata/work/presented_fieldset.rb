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

      def render(template)
        template.render
      end

    end
  end
end
require 'delegate'
require 'hydramata/work/conversions'

module Hydramata
  module Work
    class PresentedEntity < SimpleDelegator
      include Conversions

      attr_reader :entity, :presentation_structure, :presented_fieldset_builder
      def initialize(collaborators = {})
        __setobj__(collaborators.fetch(:entity))
        @presentation_structure = collaborators.fetch(:presentation_structure)
        @presented_fieldset_builder = collaborators.fetch(:presented_fieldset_builder) { default_presented_fieldset_builder }
      end

      def fieldsets
        @fieldsets ||= presented_fieldset_builder.call(entity: self, presentation_structure: presentation_structure)
      end

      protected

      def default_presented_fieldset_builder
        lambda { |*args| PresentedFieldsets(*args) }
      end
    end
  end
end

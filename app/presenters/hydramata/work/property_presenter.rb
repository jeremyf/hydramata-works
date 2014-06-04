require 'hydramata/work/base_presenter'
module Hydramata
  module Work
    class PropertyPresenter < BasePresenter

      attr_reader :fieldset
      def initialize(collaborators = {})
        property = collaborators.fetch(:property)
        @fieldset = collaborators.fetch(:fieldset)
        super(property, collaborators)
      end

      private

      def view_path_slug_for_object
        'properties'
      end

    end
  end
end

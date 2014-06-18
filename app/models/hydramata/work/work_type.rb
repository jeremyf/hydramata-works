require 'hydramata/work/data_definition'

module Hydramata
  module Work
    class WorkType < DataDefinition

      attr_writer :name_for_application_usage

      def name_for_application_usage
        @name_for_application_usage || identity
      end

    end
  end
end

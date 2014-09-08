module Hydramata
  module Works
    # Responsible for pushing the inputs onto the work.
    # Not much to see here.
    class ApplyUserInputToWork
      def self.call(collaborators = {})
        new(collaborators).call
      end
      attr_reader :attributes, :work, :property_value_strategy
      def initialize(collaborators = {})
        @attributes = collaborators.fetch(:attributes)
        @work = collaborators.fetch(:work)
        @property_value_strategy = collaborators.fetch(:property_value_strategy) { :append_values }
      end

      def call
        attributes.each do |predicate, values|
          # Yuck! @TODO refactor this.
          work.properties.<<({ predicate: predicate, values: values }, { property_value_strategy: property_value_strategy })
        end
        work
      end
    end
  end
end

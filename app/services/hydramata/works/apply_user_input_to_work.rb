module Hydramata
  module Works
    # Responsible for pushing the inputs onto the work.
    # Not much to see here.
    class ApplyUserInputToWork
      def self.call(collaborators = {})
        new(collaborators).call
      end
      attr_reader :attributes, :work
      def initialize(collaborators = {})
        @attributes = collaborators.fetch(:attributes)
        @work = collaborators.fetch(:work)
      end

      def call
        attributes.each do |predicate, values|
          work.properties << { predicate: predicate, values: values }
        end
        work
      end
    end
  end
end

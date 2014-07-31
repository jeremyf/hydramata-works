module Hydramata
  module Works
    # Responsible for pushing the inputs onto the work.
    # Not much to see here.
    class ApplyUserInputToWork
      def self.call(collaborators = {})
        new(collaborators).call
      end
      attr_reader :input, :work
      def initialize(collaborators = {})
        @input = collaborators.fetch(:input)
        @work = collaborators.fetch(:work)
        @work.work_type = @input.fetch(:work_type) { @input.fetch('work_type') }
      end

      def call
        input.each do |predicate, values|
          next if predicate.to_s == 'work_type'
          work.properties << { predicate: predicate, values: values }
        end
        work
      end
    end
  end
end

module Hydramata
  module Work
    class PredicateSet
      include Comparable

      attr_accessor :work_type
      attr_accessor :identity
      attr_accessor :presentation_sequence
      attr_accessor :name_for_application_usage

      def initialize(attributes = {})
        attributes.each do |key, value|
          self.send("#{key}=", value) if respond_to?("#{key}=")
        end
        yield self if block_given?
        self.freeze
      end

      def <=>(other)
        if other.instance_of?(self.class)
          [other.identity, other.work_type, other.presentation_sequence] <=>
            [identity, work_type, presentation_sequence]
        else
          nil
        end
      end

    end
  end
end

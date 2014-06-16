module Hydramata
  module Work
    class PredicateSet
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

      def ==(other)
        super ||
          other.instance_of?(self.class) &&
          other.identity == identity &&
          other.work_type == work_type
      end

    end
  end
end

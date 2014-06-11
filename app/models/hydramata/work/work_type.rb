module Hydramata
  module Work
    class WorkType

      attr_accessor :identity
      attr_accessor :name_for_application_usage

      def initialize(attributes = {})
        attributes.each do |key, value|
          self.send("#{key}=", value.freeze) if respond_to?("#{key}=")
        end
        yield self if block_given?
        self.freeze
      end

      def identity=(value)
        @identity = value.to_s
      end

      def to_s
        identity
      end

      def ==(other)
        other.instance_of?(self.class) &&
          identity == other.identity
      end

    end
  end
end

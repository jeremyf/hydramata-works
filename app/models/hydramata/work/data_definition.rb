module Hydramata
  module Work

    # DataDefinition is an abstract class for the Plain Old Ruby Objects (PORO)
    # that are loaded from the database storage. The irony that I am using
    # inheritance for these POROs is not lost on me.
    class DataDefinition
      include Comparable

      attr_reader :identity
      attr_writer :name_for_application_usage

      def initialize(attributes = {})
        attributes.each do |key, value|
          self.send("#{key}=", value.freeze) if respond_to?("#{key}=")
        end
        yield self if block_given?
        validate!
        self.freeze
      end

      def name_for_application_usage
        @name_for_application_usage || identity
      end

      def identity=(value)
        @identity = value.to_s
      end

      def to_s
        identity
      end

      def <=>(other)
        if other.instance_of?(self.class)
          identity <=> other.identity
        else
          nil
        end
      end

      private

      def validate!
        true
      end
    end
  end
end

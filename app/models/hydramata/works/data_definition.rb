module Hydramata
  module Works

    # DataDefinition is an abstract class for the Plain Old Ruby Objects (PORO)
    # that are loaded from the database storage. The irony that I am using
    # inheritance for these POROs is not lost on me.
    class DataDefinition
      include Comparable


      def initialize(attributes = {})
        attributes.each do |key, value|
          self.send("#{key}=", value.freeze) if respond_to?("#{key}=")
        end
        yield self if block_given?
        validate!
        self.freeze
      end

      attr_writer :name_for_application_usage
      def name_for_application_usage
        @name_for_application_usage || identity
      end

      def to_translation_key_fragment
        name_for_application_usage
      end

      attr_reader :identity
      def identity=(value)
        @identity = value.to_s
      end

      def to_s
        identity
      end

      def to_sym
        to_translation_key_fragment.to_sym
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

require 'active_support/core_ext/object/blank'

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

      def name_for_application_usage=(value)
        @name_for_application_usage = value.present? ? value : nil
      end

      def name_for_application_usage
        @name_for_application_usage || identity
      end

      def translation_key_fragment=(value)
        @translation_key_fragment = value.present? ? value : nil
      end

      def to_translation_key_fragment
        @translation_key_fragment || name_for_application_usage
      end
      alias_method :translation_key_fragment, :to_translation_key_fragment

      def view_path_fragment=(value)
        @view_path_fragment = value.present? ? value : nil
      end

      def to_view_path_fragment
        @view_path_fragment || name_for_application_usage
      end
      alias_method :view_path_fragment, :to_view_path_fragment

      def name
        name_for_application_usage
      end

      attr_reader :identity
      def identity=(value)
        @identity = value.to_s
      end

      def to_s
        name_for_application_usage
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

require 'active_support/core_ext/array/wrap'
require 'hydramata/work/conversions'
module Hydramata
  module Work
    # A container for Property objects. It provides ordered access to
    # properties. The corresponding specs go into further details on ordering.
    class PropertySet
      include Conversions
      include ::Enumerable

      def initialize(options = {})
        @properties = {}
        self.predicate_set = options.fetch(:predicate_set) { default_predicate_set }
      end
      attr_reader :predicate_set

      def name
        predicate_set.identity
      end

      def <<(input)
        property = Property(input)
        if properties[property.predicate.to_s]
          properties[property.predicate.to_s] << property.values
        else
          properties[property.predicate.to_s] = property
        end
      end

      # If the key is missing, return a quasi-null object.
      def [](key)
        properties[key.to_s] || Property(predicate: key)
      end

      def predicates
        properties.keys
      end

      def fetch(key)
        properties.fetch(key.to_s)
      end

      def ==(other)
        # Because properties is a private method.
        (other.instance_of?(properties.class) && properties == other) ||
        (other.instance_of?(self.class) && other == properties)
      end

      def each
        properties.each do |_key, property|
          yield(property)
        end
      end

      # Conversion::PresentedFieldsets interacts with this.
      # Consider extracting the shared behavior into that function. Perhaps
      # making a proper class.
      def subset(keys, receiver = self.class.new, property_builder = nil)
        property_builder ||= ->(builder) { builder }
        Array.wrap(keys).each_with_object(receiver).each do |key, collector|
          # A concession regarding null property; If you ask for the keys, I'll
          # give them to you; it just may be an empty value.
          collector << property_builder.call(self[key])
          collector
        end
      end

      private

      attr_reader :properties

      def default_predicate_set
        { identity: 'identity' }
      end

      def predicate_set=(value)
        @predicate_set = PredicateSet(value)
      end
    end
  end
end

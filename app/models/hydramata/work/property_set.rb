require 'active_support/core_ext/array/wrap'
require 'hydramata/work/property'
require 'hydramata/work/conversions'
module Hydramata
  module Work
    class PropertySet
      include Conversions
      include ::Enumerable

      def initialize(options = {})
        @properties = {}
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
        properties.each do |key, property|
          yield(property)
        end
      end

      def subset(keys)
        Array.wrap(keys).each_with_object(self.class.new).each do |key, property_set|
          # A concession regarding null property; If you ask for the keys, I'll
          # give them to you; it just may be an empty value.
          property_set << self[key]
          property_set
        end
      end

      def _equal_properties?(other_properties)
        properties == other_properties
      end

      private

      def properties
        @properties
      end

    end
  end
end

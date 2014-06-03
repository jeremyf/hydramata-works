require 'active_support/core_ext/array/wrap'
require 'hydramata/work/property'
require 'hydramata/work/conversions'
module Hydramata
  module Work
    class PropertySet
      include Conversions
      include ::Enumerable

      def initialize(*args)
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

      def [](key)
        properties[key.to_s] || Property(predicate: key)
      end

      def fetch(key)
        properties.fetch(key.to_s)
      end

      def each
        properties.each do |key, property|
          yield(property)
        end
      end

      def subset(keys)
        Array.wrap(keys).each_with_object(self.class.new).each do |key, property_set|
          property_set << properties[key]
          property_set
        end
      end

      private

      def properties
        @properties
      end

    end
  end
end

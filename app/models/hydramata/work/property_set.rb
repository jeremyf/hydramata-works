require 'active_support/core_ext/array/wrap'
module Hydramata
  module Work
    class PropertySet
      include ::Enumerable

      def initialize(*args)
        @properties = {}
      end

      def <<(property)
        predicate  = property[:predicate]
        value = property[:value]
        properties[predicate.to_s] ||= []
        properties[predicate.to_s] << value
      end

      def [](key)
        normalize_values(properties[key.to_s])
      end

      def fetch(key)
        normalize_values(properties.fetch(key.to_s))
      end

      def each
        properties.each do |key, value|
          yield(key.to_s, normalize_values(value))
        end
      end

      private

      def properties
        @properties
      end

      def normalize_values(value)
        Array.wrap(value)
      end
    end
  end
end

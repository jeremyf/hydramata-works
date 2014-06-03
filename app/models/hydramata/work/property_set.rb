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
        @properties[predicate.to_s] ||= []
        @properties[predicate.to_s] << value
      end

      def [](key)
        Array.wrap(@properties[key.to_s])
      end

      def fetch(key)
        @properties.fetch(key.to_s)
      end

      def each
        @properties.each do |key, value|
          yield(key, value)
        end
      end

    end
  end
end

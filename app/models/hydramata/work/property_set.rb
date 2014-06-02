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
        fetch(key)
      rescue KeyError
        []
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

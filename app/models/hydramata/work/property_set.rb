require 'active_support/core_ext/array/wrap'
require 'hydramata/work/conversions'
module Hydramata
  module Work
    class PropertySet
      include Conversions
      include ::Enumerable

      attr_reader :name
      def initialize(options = {})
        @properties = {}
        @name = options.fetch(:name) { default_name }
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

      def subset(keys, receiver = self.class.new, property_builder = nil)
        property_builder ||= lambda {|o| o }
        Array.wrap(keys).each_with_object(receiver).each do |key, collector|
          # A concession regarding null property; If you ask for the keys, I'll
          # give them to you; it just may be an empty value.
          collector << property_builder.call(self[key])
          collector
        end
      end

      private

      def properties
        @properties
      end

      def default_name
        'unamed property set'
      end

    end
  end
end

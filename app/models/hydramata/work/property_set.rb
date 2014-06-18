require 'active_support/core_ext/array/wrap'
require 'hydramata/work/conversions'
module Hydramata
  module Work
    # A container for Property objects. It provides ordered access to
    # property_store. The corresponding specs go into further details on ordering.
    class PropertySet
      include Conversions
      include ::Enumerable

      def initialize(options = {})
        @property_store = {}
        self.predicate_set = options.fetch(:predicate_set) { default_predicate_set }
      end
      attr_reader :predicate_set

      def name
        predicate_set.identity
      end

      def <<(input)
        property = Property(input)
        if property_store[property.predicate.to_s]
          property_store[property.predicate.to_s] << property.values
        else
          property_store[property.predicate.to_s] = property
        end
      end

      # If the key is missing, return a quasi-null object.
      def [](key)
        property_store[key.to_s] || Property(predicate: key)
      end

      def predicates
        property_store.keys
      end

      def fetch(key)
        property_store.fetch(key.to_s)
      end

      def ==(other)
        # Because property_store is a private method.
        (other.instance_of?(property_store.class) && property_store == other) ||
        (other.instance_of?(self.class) && other == property_store)
      end

      def each
        property_store.each do |_key, property|
          yield(property)
        end
      end

      def properties
        property_store.collect {|_, property| property }
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

      attr_reader :property_store

      def default_predicate_set
        { identity: 'identity' }
      end

      def predicate_set=(value)
        @predicate_set = PredicateSet(value)
      end
    end
  end
end

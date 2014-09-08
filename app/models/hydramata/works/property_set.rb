require 'active_support/core_ext/array/wrap'
require 'active_support/core_ext/module/delegation'
require 'hydramata/works/conversions/property'
require 'hydramata/works/conversions/predicate_set'

module Hydramata
  module Works
    # A container for Property objects. It provides ordered access to
    # property_store. The corresponding specs go into further details on ordering.
    class PropertySet
      include Conversions
      include ::Enumerable

      def initialize(options = {})
        @property_store = {}
        self.predicate_set = options.fetch(:predicate_set) { default_predicate_set }
        self.property_value_strategy = options.fetch(:property_value_strategy) { default_property_value_strategy }
      end
      attr_reader :predicate_set, :property_value_strategy

      delegate :name, to: :predicate_set

      def <<(input, options = {})
        property = Property(input)
        strategy = options.fetch(:property_value_strategy) { property_value_strategy }
        existing_property = property_store[property.predicate.to_s]
        if existing_property
          existing_property.send(strategy, property.values)
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

      def key?(key)
        property_store.key?(key.to_s)
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

      def property_value_strategy=(value)
        if valid_property_value_strategy?(value)
          @property_value_strategy = value
        else
          raise RuntimeError, "Invalid property_value_strategy #{value.inspect}."
        end
      end

      attr_reader :property_store

      def valid_property_value_strategy?(value)
        [:append_values, :replace_values].include?(value)
      end

      def default_property_value_strategy
        :append_values
      end

      def default_predicate_set
        { identity: 'unknown' }
      end


      def predicate_set=(value)
        @predicate_set = PredicateSet(value)
      end
    end
  end
end

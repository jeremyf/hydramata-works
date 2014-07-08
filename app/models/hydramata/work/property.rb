require 'active_support/core_ext/array/wrap'
require 'hydramata/work/conversions'

module Hydramata
  module Work
    # The responsibility of a Property is to be a collection of values for
    # a given predicate. In other words, this represents the Predicate/Object
    # components of an RDF Triple.
    #
    # Why not use RDF? Because not everything we are working with is in RDF.
    class Property
      def self.===(other)
        super || other.instance_of?(self)
      end

      include ::Enumerable
      include Conversions

      attr_reader :predicate, :values, :value_parser
      def initialize(options = {})
        self.predicate = options.fetch(:predicate)
        @value_parser = options.fetch(:value_parser) { default_value_parser }
        @values = []
        push(options[:values])
        push(options[:value])
      end

      def name
        predicate
      end

      # Because who wants to remember which way to access this?
      alias_method :value, :values

      def to_translation_key_fragment
        predicate.to_translation_key_fragment
      end

      def each(&block)
        values.each(&block)
      end

      def <<(values)
        Array.wrap(values).each do |value|
          value_parser.call(predicate: predicate, value: value) do |response|
            @values << Value(response)
          end
        end
        self
      end
      alias_method :push, :<<

      def ==(other)
        super ||
          other.instance_of?(self.class) &&
          other.predicate == predicate &&
          other.values == values
      end

      private

      def predicate=(value)
        @predicate = Predicate(value)
      end

      def default_value_parser
        require 'hydramata/work/value_parser'
        ValueParser
      end
    end
  end
end

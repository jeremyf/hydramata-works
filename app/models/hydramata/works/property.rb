require 'active_support/core_ext/array/wrap'
require 'active_support/core_ext/module/delegation'
require 'hydramata/works/conversions/predicate'
require 'hydramata/works/conversions/value'

module Hydramata
  module Works
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

      def initialize(options = {})
        self.predicate = options.fetch(:predicate)
        @value_parser = options.fetch(:value_parser) { default_value_parser }
        @values = []
        push(options[:values])
        push(options[:value])
      end

      attr_reader :predicate
      attr_reader :values
      # Because who wants to remember which way to access this?
      alias_method :value, :values

      attr_reader :value_parser
      private :value_parser

      delegate :name, to: :predicate
      delegate :to_translation_key_fragment, to: :predicate
      delegate :each, to: :values

      def replace_values(values)
        @values = []
        append_values(values)
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
      alias_method :append_values, :<<

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
        require 'hydramata/works/value_parser'
        ValueParser
      end
    end
  end
end

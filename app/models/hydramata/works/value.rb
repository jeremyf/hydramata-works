require 'delegate'

module Hydramata
  module Works
    # Because it may be helpful to see the raw object
    class Value < SimpleDelegator
      def initialize(options = {})
        value = options.fetch(:value)
        __setobj__(value)
        @raw_object = options.fetch(:raw_object) { default_raw_object }
        yield(self) if block_given?
      end

      # When working with the Value, it would be helpful to know the base object
      attr_reader :raw_object

      def inspect
        format('#<%s:%#0x value=%s raw_object=%s>', self.class, __id__, __getobj__.inspect, raw_object.inspect)
      end

      def to_param
        raw_object.to_param
      end

      def to_key
        raw_object.to_key
      end

      def instance_of?(klass)
        super || __getobj__.instance_of?(klass)
      end

      def ==(other)
        super || other == __getobj__
      end

      def name_for_application_usage
        "value"
      end

      private

      def default_raw_object
        __getobj__
      end
    end
  end
end

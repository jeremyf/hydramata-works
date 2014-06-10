require 'delegate'

module Hydramata
  module Work
    # Because it may be helpful to see the raw object
    class Value < SimpleDelegator
      attr_reader :raw_object
      def initialize(options = {})
        value = options.fetch(:value)
        __setobj__(value)
        @raw_object = options.fetch(:raw_object) { default_raw_object }
        yield(self) if block_given?
      end

      def inspect
        format('#<%s:%#0x value=%s raw_object=%s>', self.class, __id__, __getobj__.inspect, raw_object.inspect)
      end

      def instance_of?(klass)
        super || __getobj__.instance_of?(klass)
      end

      def ==(other)
        super || other == __getobj__
      end

      private

      def default_raw_object
        __getobj__
      end
    end
  end
end

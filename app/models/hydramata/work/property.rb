module Hydramata
  module Work
    # The responsibility of a Property is to be a collection of values for
    # a given predicate. In other words, this represents the Predicate/Object
    # components of an RDF Triple.
    #
    # Why not use RDF? Because not everything we are working with is in RDF.
    class Property
      attr_reader :predicate, :values
      def initialize(options = {})
        @predicate = options.fetch(:predicate)
        self.values = options.fetch(:values) { default_values }
      end

      def <<(value)
        @values << value
      end

      alias_method :value, :values

      def ==(other)
        super ||
          other.instance_of?(self.class) &&
          other.predicate == predicate &&
          other.values == values
      end

      private

      def default_values
        []
      end

      def values=(options)
        @values = [options].flatten.compact
      end
    end
  end
end

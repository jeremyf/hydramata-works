module Hydramata
  module Work
    class Property
      attr_reader :predicate, :values
      def initialize(options = {})
        @predicate = options.fetch(:predicate)
        @values = options.fetch(:values) { default_values }
      end

      def <<(value)
        @values << value
      end

      alias_method :value, :values

      private

      def default_values
        []
      end
    end
  end
end
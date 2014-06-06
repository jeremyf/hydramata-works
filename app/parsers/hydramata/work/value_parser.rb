module Hydramata
  module Work
    module ValueParser
      module_function
      def call(options = {}, &block)
        parser = parser_for(options)
        value = options.fetch(:value)
        parser.call(value, &block)
      end

      def parser_for(options = {})
        parser_finder = options.fetch(:parser_finder) { default_parser_finder }
        parser_finder.call(options)
      end

      def default_parser_finder
        ->(options) do
          require 'hydramata/work/predicate_parsers/simple_parser'
          ValueParsers::SimpleParser
        end
      end
      private_class_method :default_parser_finder

    end
  end
end

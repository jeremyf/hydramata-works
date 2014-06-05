module Hydramata
  module Work

    # Responsible for finding the appropriate predicate parser based on the
    # input context, then calling the found parser.
    #
    # See lib/hydramata/work/linters.rb for the interface definition of a
    # datastream parser.
    module PredicateParser

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
          PredicateParsers::SimpleParser
        end
      end
      private_class_method :default_parser_finder
    end
  end
end

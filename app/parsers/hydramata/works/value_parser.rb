module Hydramata
  module Works
    module ValueParser
      module_function
      def call(options = {}, &block)
        value = options.fetch(:value)
        if value.respond_to?(:raw_object)
          block.call(value: value, raw_object: value.raw_object)
        else
          parser = parser_for(options)
          parser.call(value, &block)
        end
      end

      def parser_for(options = {})
        parser_finder = options.fetch(:parser_finder) { default_parser_finder }
        parser_finder.call(options)
      end

      def default_parser_finder
        ->(options) do
          require 'hydramata/works/value_parsers'
          ValueParsers.find(options)
        end
      end
      private_class_method :default_parser_finder

    end
  end
end

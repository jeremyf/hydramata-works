require 'hydramata/work/value_parsers/simple_parser'
require 'hydramata/work/value_parsers/date_parser'
require 'hydramata/work/value_parsers/interrogation_parser'

module Hydramata
  module Work
    module ValueParsers
      module_function
      def find(options = {})
        predicate = options.fetch(:predicate)
        parser_class_name = predicate.value_parser_name

        # Catching behavioral difference between const_defined? in Ruby 2.0 and
        # Ruby 2.1
        if parser_class_name =~ /\A::/
          SimpleParser
        elsif const_defined?(parser_class_name)
          const_get(parser_class_name)
        else
          SimpleParser
        end
      rescue NameError, TypeError
        SimpleParser
      end
    end
  end
end

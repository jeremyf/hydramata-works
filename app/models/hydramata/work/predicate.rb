require 'hydramata/work/data_definition'
require 'hydramata/work/validations_parser'
require 'active_support/core_ext/array/wrap'

module Hydramata
  module Work
    class Predicate < DataDefinition

      def initialize(*args, &block)
        @validations = []
        super(*args, &block)
      end

      attr_accessor :datastream_name
      attr_accessor :value_coercer_name
      attr_accessor :value_parser_name
      attr_accessor :indexing_strategy
      attr_reader :validations

      def validations=(value)
        @validations = ValidationsParser.call(value)
      end

    end
  end
end

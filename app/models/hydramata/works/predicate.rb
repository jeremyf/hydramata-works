require 'hydramata/works/data_definition'
require 'hydramata/works/validations_parser'
require 'active_support/core_ext/array/wrap'

module Hydramata
  module Works
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

      attr_reader :itemprop_schema_dot_org
      def itemprop_schema_dot_org=(value)
        string = value.to_s.strip
        if string.size == 0
          @itemprop_schema_dot_org = nil
        else
          @itemprop_schema_dot_org = string
        end
      end
    end
  end
end

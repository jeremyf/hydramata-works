require 'hydramata/work/data_definition'

module Hydramata
  module Work
    class Predicate < DataDefinition

      attr_accessor :datastream_name
      attr_accessor :value_coercer_name
      attr_accessor :value_parser_name
      attr_accessor :indexing_strategy

    end
  end
end

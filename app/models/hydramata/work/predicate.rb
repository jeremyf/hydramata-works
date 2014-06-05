module Hydramata
  module Work
    # A data-structure object that helps in transitioning a predicate from
    # one form to another (i.e. persistence to memory, memory to input)
    #
    # @TODO - Create an ActiveRecord::Base model of this.
    class Predicate
      attr_accessor :name
      attr_accessor :uri
      attr_accessor :default_datastream_name
      attr_accessor :default_coercer_class_name
      attr_accessor :default_parser_class_name
      attr_accessor :default_indexing_strategy
    end
  end
end

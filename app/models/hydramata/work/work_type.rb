require 'hydramata/work/data_definition'
require 'hydramata/work/conversions/predicate_set'
require 'active_support/core_ext/array/wrap'

module Hydramata
  module Work
    class WorkType < DataDefinition
      include Conversions

      def initialize(*args, &block)
        @predicate_sets = []
        super(*args, &block)
      end

      attr_reader :predicate_sets
      def predicate_sets=(things)
        Array.wrap(things).each do |thing|
          self.predicate_sets << PredicateSet(thing)
        end
      end
    end
  end
end

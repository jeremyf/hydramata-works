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
        @predicate_sets = []
        Array.wrap(things).each do |thing|
          @predicate_sets << PredicateSet(thing)
        end
      end

      alias_method :fieldsets, :predicate_sets
    end
  end
end

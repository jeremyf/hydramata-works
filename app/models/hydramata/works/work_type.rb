require 'hydramata/works/data_definition'
require 'hydramata/works/conversions/predicate_set'
require 'active_support/core_ext/array/wrap'

module Hydramata
  module Works
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
      alias_method :fieldsets=, :predicate_sets=

      def itemtype_schema_dot_org
        @itemtype_schema_dot_org || default_itemtype_schema_dot_org
      end

      def itemtype_schema_dot_org=(value)
        string = value.to_s.strip
        if string.size == 0
          @itemtype_schema_dot_org = nil
        else
          if string =~ /\Ahttp/
            @itemtype_schema_dot_org = string
          else
            @itemtype_schema_dot_org = File.join('http://schema.org', string)
          end
        end
      end

      private

      def default_itemtype_schema_dot_org
        'http://schema.org/Thing'
      end
    end
  end
end

require 'hydramata/works/data_definition'
require 'hydramata/works/conversions/predicate_set'
require 'active_support/core_ext/array/wrap'

module Hydramata
  module Works
    # Responsible for defining the suggested structure for a Work.
    #
    # The structure is based on the order of the #predicate_sets and within
    # those, their #predicates.
    # And it is suggested because Hydramata::Works acknowledges that each Work
    # is unique and may have additional properties (and therefore predicates)
    # defined.
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

      def to_presenter
        require 'hydramata/works/work_type_presenter'
        WorkTypePresenter.new(self)
      end

      private

      def default_itemtype_schema_dot_org
        'http://schema.org/Thing'
      end
    end
  end
end

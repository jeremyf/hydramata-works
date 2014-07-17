require 'active_support/core_ext/array/wrap'
require 'hydramata/works/conversions/predicate'
require 'hydramata/works/data_definition'

module Hydramata
  module Works

    # A PredicateSet is analogous to a PropertySet, except it does not include
    # values.
    class PredicateSet < DataDefinition
      include Conversions

      # The WorkType associated with this PredicateSet.
      attr_accessor :work_type

      # Relative to other PredicateSets, when should this be presented?
      attr_accessor :presentation_sequence

      # What are the predicates associated with this PredicateSet.
      # Order is significant.
      attr_reader :predicates

      def <=>(other)
        if other.instance_of?(self.class)
          [work_type, identity, presentation_sequence] <=>
            [other.work_type, other.identity, other.presentation_sequence]
        else
          nil
        end
      end

      def predicates=(items)
        @predicates = []
        Array.wrap(items).each do |item|
          @predicates << Predicate(item)
        end
      end

      protected

      def validate!
        if identity.nil?
          raise RuntimeError, "#{self.class}(#{inspect}) is invalid"
        else
          true
        end
      end
    end
  end
end

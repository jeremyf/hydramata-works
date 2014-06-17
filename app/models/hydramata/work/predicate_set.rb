require 'active_support/core_ext/array/wrap'
require 'hydramata/work/conversions/predicate'

module Hydramata
  module Work

    # A PredicateSet is analogous to a PropertySet, except it does not include
    # values.
    class PredicateSet
      include Comparable
      include Conversions

      attr_accessor :work_type
      attr_accessor :identity
      attr_accessor :presentation_sequence
      attr_accessor :name_for_application_usage
      attr_accessor :predicates

      def initialize(attributes = {})
        attributes.each do |key, value|
          self.send("#{key}=", value) if respond_to?("#{key}=")
        end
        yield self if block_given?
        validate!
        self.freeze
      end

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
          raise RuntimeError, "#{self.class}(#{attributes.inspect}) is invalid"
        else
          true
        end
      end
    end
  end
end

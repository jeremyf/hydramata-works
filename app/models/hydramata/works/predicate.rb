require 'hydramata/works/data_definition'
require 'hydramata/works/validations_parser'
require 'active_support/core_ext/array/wrap'

module Hydramata
  module Works

    # A Data Structure object that is responsible for providing guidance for
    # transforming a Predicate/Value pair.
    class Predicate < DataDefinition

      def initialize(*args, &block)
        @validations = []
        super(*args, &block)
      end

      attr_writer :datastream_name

      # In what datastream will we store this predicate.
      # It is possible that we will find the predicate in another datastream,
      # but when the object is saved, it would be to this datastream.
      def datastream_name
        @datastream_name || 'descMetadata'
      end

      attr_writer :value_parser_name

      # When we are loading the Predicate from persistence, what is the
      # class name of the Parser we should use to get the value into a suitable
      # format for interacting with the system.
      def value_parser_name
        @value_parser_name || 'SimpleParser'
      end

      # When we go to index this predicate, what is the strategy to apply?
      # @TODO - This will require further fleshing out.
      attr_accessor :indexing_strategy

      # What are the validations for this object. The validations should
      # conform to ActiveModel::Validations.validates method structure
      # http://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates
      attr_reader :validations

      attr_accessor :namespace_context_prefix
      attr_accessor :namespace_context_url
      attr_accessor :namespace_context_name

      attr_writer :value_presenter_class_name
      def value_presenter_class_name
        @value_presenter_class_name || 'ValuePresenter'
      end

      # @TODO - Instead of evaluating the validations, consider parsing the
      # validations when needed.
      def validations=(value)
        @validations = ValidationsParser.call(value)
      end

      def required?
        validations.present?
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

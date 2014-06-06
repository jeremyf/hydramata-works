module Hydramata
  module Work
    class Predicate

      def self.find_by_identity(identity, collaborators = {})
        storage_lookup = collaborators.fetch(:storage_lookup) { default_storage_lookup }
        storage_lookup.call(identity) || new(identity: identity)
      end

      def self.default_storage_lookup
        -> (identity) do
          begin
            require 'hydramata/work/predicates/storage'
            Predicates::Storage.find_by_identity(identity)
          rescue ActiveRecord::ConnectionNotEstablished
            nil
          end
        end
      end
      private_class_method :default_storage_lookup

      attr_accessor :identity
      attr_accessor :name_for_application_usage
      attr_accessor :default_datastream_name
      attr_accessor :default_coercer_class_name
      attr_accessor :default_parser_class_name
      attr_accessor :default_indexing_strategy

      def initialize(attributes = {})
        attributes.each do |key, value|
          self.send("#{key}=", value.freeze) if respond_to?("#{key}=")
        end
        yield self if block_given?
        self.freeze
      end

      def identity=(value)
        @identity = value.to_s
      end

      def to_s
        identity
      end

      def ==(other)
        instance_of?(self.class) &&
          identity == other.identity
      end

    end
  end
end

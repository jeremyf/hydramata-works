require 'active_support/core_ext/array/wrap'

module Hydramata
  module Work
    class ValidationService
      def self.call(entity)
        new(entity).call
      end

      attr_reader :entity, :validator_namespaces
      def initialize(entity, collaborators = {})
        @entity = entity
        self.validator_namespaces = collaborators.fetch(:validator_namespaces) { default_validator_namespaces }
      end

      def call
        # @TODO - This is an awful lot of information about the validation
        # structure.
        entity.properties.each do |property|
          predicate = property.predicate
          predicate.validations.each do |validator_name, options|
            validate(predicate, validator_name, options)
          end
        end
        nil
      end

      private

      def validate(predicate, validator_name, options)
        return unless options
        validator = validator_for(validator_name)
        validation_options = parse_validates_options(options)
        validation_options[:attributes] = predicate
        validator.new(validation_options).validate(entity)
      end

      def validator_for(validator_name)
        validator_class_name = "#{validator_name.to_s.camelize}Validator"
        validator = nil
        validator_namespaces.each do |namespace|
          begin
            validator = "#{namespace}::#{validator_class_name}".constantize
            break
          rescue NameError
            next
          end
        end
        validator || validator_class_name.constantize
      end

      # Cribbed from ActiveModel::Validations#_parse_validates_options
      # in Rails 4.0.x and 4.1.x
      def parse_validates_options(options)
        case options
        when TrueClass
          {}
        when Hash
          options
        when Range, Array
          { :in => options }
        else
          { :with => options }
        end
      end

      def default_validator_namespaces
        require 'active_model/validations'
        ActiveModel::Validations
      end

      def validator_namespaces=(names)
        @validator_namespaces = Array.wrap(names)
      end

    end
  end
end

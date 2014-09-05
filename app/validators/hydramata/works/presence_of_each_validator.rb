require 'active_support/core_ext/array/wrap'

module Hydramata
  module Works
    # Responsible for validating an array of items using the underlying
    # presence validator.
    class PresenceOfEachValidator < SimpleDelegator
      def initialize(options, collaborators = {})
        @base_validator_builder = collaborators.fetch(:base_validator_builder) { default_base_validator_builder }
        __setobj__(base_validator_builder.call(options))
      end
      attr_reader :base_validator_builder
      private :base_validator_builder

      def validate(record)
        attributes.each do |attribute|
          value = record.read_attribute_for_validation(attribute)
          next if (value.nil? && options[:allow_nil]) || (value.blank? && options[:allow_blank])
          validate_each(record, attribute, value)
        end
      end

      def validate_each(record, attribute, values)
        wrapped_values = Array.wrap(values)
        if wrapped_values.present?
          wrapped_values.each do |value|
            previous_error_count = (record.errors[attribute] || []).size
            __getobj__.validate_each(record, attribute, value)
            messages = record.errors[attribute]
            if messages && messages.size > previous_error_count
              record.errors.add(attribute, fixed_message(value, messages.pop))
            end
          end
        else
          __getobj__.validate_each(record, attribute, nil)
        end
        record.errors[attribute]
      end

      private

      def fixed_message(value, message)
        "value #{value.inspect} #{message}"
      end

      def default_base_validator_builder
        require 'active_model/validations/presence'
        ActiveModel::Validations::PresenceValidator.method(:new)
      end
    end
  end
end

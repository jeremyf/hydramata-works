require 'active_support/core_ext/array/wrap'
require 'active_model/validations/presence'

module Hydramata
  module Works
    class PresenceOfEachValidator < ActiveModel::Validations::PresenceValidator
      def validate_each(record, attribute, values)
        wrapped_values = Array.wrap(values)
        if wrapped_values.present?
          wrapped_values.each do |value|
            previous_error_count = record.errors[attribute].size rescue 0
            super(record, attribute, value)
            messages = record.errors[attribute]
            if messages && messages.size > previous_error_count
              record.errors.add(attribute, fixed_message(value, messages.pop))
            end
          end
        else
          super(record, attribute, nil)
        end
        record.errors[attribute]
      end

      private

      def fixed_message(value, message)
        "value #{value.inspect} #{message}"
      end

    end
  end
end

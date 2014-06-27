require 'active_support/core_ext/array/wrap'

module Hydramata
  module Work
    # Responsible for coordinating the potentially complicated dom attributes
    # for a given context.
    module DomAttributesBuilder
      module_function
      # context - a data structure; provided as a placeholder; Maybe we could
      # supply additional attributes based on the context
      def call(context, attributes = {}, defaults = {})
        returning_value = attributes.dup
        defaults.each_pair do |key, value|
          if returning_value.key?(key)
            returning_value[key] = Array.wrap(returning_value[key]) + Array.wrap(value)
          else
            returning_value[key] = Array.wrap(value)
          end
        end
        returning_value
      end
    end
  end
end
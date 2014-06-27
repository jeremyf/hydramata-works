module Hydramata
  module Work
    module DomAttributesBuilder
      module_function
      def call(context, attributes = {}, defaults = {})
        returning_value = attributes.dup
        defaults.each_pair do |key, value|
          if returning_value.key?(key)
            returning_value[key] += value
          else
            returning_value[key] = value
          end
        end
        returning_value
      end
    end
  end
end
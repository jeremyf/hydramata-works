require 'json'
module Hydramata
  module Work
    module ValidationsParser
      module_function
      def call(input)
        case input
        when NilClass then {}
        when String then
          if input.empty?
            {}
          else
            JSON.parse(input)
          end
        when Hash then input
        else
          raise RuntimeError, "Unable to parse #{input.inspect} for Validations"
        end
      end
    end
  end
end

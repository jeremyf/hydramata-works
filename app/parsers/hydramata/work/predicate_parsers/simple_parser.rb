module Hydramata
  module Work
    module PredicateParsers
      class SimpleParser
        def self.call(object, &block)
          # A short circuit to prevent instantiating another object.
          # The method body of this method should be identical to the
          # method body of the instance's call
          yield(value: object)
        end

        def call(object, &block)
          yield(value: object)
        end
      end
    end
  end
end

module Hydramata
  module Work
    module PredicateParsers
      class SimpleParser
        def self.call(object, &block)
          yield(value: object)
        end

        def call(object, &block)
          yield(value: object)
        end
      end
    end
  end
end

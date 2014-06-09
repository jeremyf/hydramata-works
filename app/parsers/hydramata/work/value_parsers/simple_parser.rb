module Hydramata
  module Work
    module ValueParsers
      # A comically simple parser.
      # You get what you give.
      module SimpleParser
        module_function
        def call(object, &block)
          block.call(value: object, raw_object: object)
        end
      end
    end
  end
end

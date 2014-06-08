module Hydramata
  module Work
    module ValueParsers
      module DateParser
        module_function
        def call(object, &block)
          date = Date.parse(object.to_s)
          block.call(value: date)
        end
      end
    end
  end
end

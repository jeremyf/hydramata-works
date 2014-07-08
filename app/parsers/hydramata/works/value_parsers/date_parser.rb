module Hydramata
  module Works
    module ValueParsers
      module DateParser
        module_function
        def call(object, &block)
          date = Date.parse(object.to_s)
          block.call(value: date, raw_object: object)
        end
      end
    end
  end
end

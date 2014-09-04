module Hydramata
  module Works
    module ValueParsers
      module AttachmentParser
        module_function
        def call(object, &block)
          block.call(value: object.original_filename, raw_object: object)
        end
      end
    end
  end
end

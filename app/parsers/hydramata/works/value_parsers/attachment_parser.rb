module Hydramata
  module Works
    module ValueParsers
      module AttachmentParser
        module_function
        def call(object, &block)
          if object.respond_to?(:raw_object)
            block.call(value: object, raw_object: object.raw_object)
          elsif object.respond_to?(:original_filename)
            block.call(value: object.original_filename, raw_object: object)
          elsif object.respond_to?(:file_name)
            block.call(value: object.file_name, raw_object: object)
          else
            block.call(value: object, raw_object: object)
          end
        end
      end
    end
  end
end

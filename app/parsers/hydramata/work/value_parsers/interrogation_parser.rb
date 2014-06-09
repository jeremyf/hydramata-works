module Hydramata
  module Work
    module ValueParsers
      module InterrogationParser
        module_function
        def call(object, &block)
          value =
          case object
          when RDF::Literal then object.to_s
          else
            object
          end
          block.call(value: value, raw_object: object)
        end
      end
    end
  end
end

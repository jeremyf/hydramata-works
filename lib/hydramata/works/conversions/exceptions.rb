require 'hydramata/works/conversions/exceptions'

module Hydramata
  module Works
    # Taking a que from Avdi Grimm's "Confident Ruby", the Conversion module
    # is responsible for coercing the inputs to another format.
    #
    # This is somewhat experimental, though analogous to the Array() method in
    # base ruby.
    module Conversions
      class ConversionError < RuntimeError
        def initialize(class_name, input)
          super("Could not convert #{input.inspect} to #{class_name}")
        end
      end
    end
  end
end

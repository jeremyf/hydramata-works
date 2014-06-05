module Hydramata
  module Work

    # Responsible for finding the appropriate predicate parser based on the
    # input context, then calling the found parser.
    #
    # See lib/hydramata/work/linters.rb for the interface definition of a
    # datastream parser.
    module PredicateParser

      module_function

      def call(options = {}, &block)
      end
    end
  end
end

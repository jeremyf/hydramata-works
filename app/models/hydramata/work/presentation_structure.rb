module Hydramata
  module Work
    # This is responsible for defining
    #
    # Taking a queue from HTML, a fieldset gives meaning to a group of
    # attributes. Conceptually it is providing the sequence in which to render
    # attributes.
    class PresentationStructure
      def initialize
        yield(self) if block_given?
      end

      def fieldsets
        @fieldsets ||= []
      end
    end
  end
end

module Hydramata
  module Works
    # This is responsible for defining
    #
    # Taking a queue from HTML, a fieldset gives meaning to a group of
    # attributes. Conceptually it is providing the sequence in which to render
    # attributes.
    #
    # @TODO - Does this class even make sense? Given that I am grabbing the
    # presentation structure from the work type.
    class PresentationStructure
      def self.build_from(object)
        new do |structure|
          object.predicate_sets.each do |predicate_set|
            structure.fieldsets << predicate_set
          end
        end
      end

      def initialize
        yield(self) if block_given?
      end

      def fieldsets
        @fieldsets ||= []
      end
    end
  end
end

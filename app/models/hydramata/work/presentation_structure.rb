module Hydramata
  module Work
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
module Hydramata
  module Work
    class PropertySet < Array

      def initialize(entity)
        @entity = entity
        super()
      end

      def property(key)
        each_with_object([]) do |entry, mem|
          if entry.fetch(:predicate).to_s == key.to_s
            mem << entry.fetch(:value)
          end
          mem
        end
      end

    end
  end
end

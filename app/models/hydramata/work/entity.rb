module Hydramata
  module Work
    # Responsible for being the in ruby representation of a set of Properties.
    #
    # Unlike the [ActiveRecord pattern](http://www.martinfowler.com/eaaCatalog/activeRecord.html),
    # there is no direct connection to a data storage. This is instead analogous
    # to the Entity of the [DataMapper pattern](http://www.martinfowler.com/eaaCatalog/dataMapper.html)
    # as implemented in [Lotus::Models](https://github.com/lotus/model#entities).
    #
    # Unlike a Lotus::Model, the Work is an arbitrary collection of Properties.
    class Entity
      def initialize
        yield(self) if block_given?
      end

      def properties
        @properties ||= []
      end

      def property(key)
        properties.each_with_object([]) do |entry, mem|
          if entry.fetch(:predicate) == key.to_sym
            mem << entry.fetch(:value)
          end
        end
      end
    end
  end
end

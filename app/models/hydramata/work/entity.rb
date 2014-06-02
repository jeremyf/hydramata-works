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
      extend Forwardable
      def initialize(collaborators = {})
        @properties = collaborators.fetch(:properties_container) { default_properties_container }
        yield(self) if block_given?
      end

      attr_accessor :work_type

      def properties
        @properties
      end

      def property(predicate)
        @properties[predicate]
      end

      private

      def default_properties_container
        require 'hydramata/work/property_set'
        PropertySet.new(self)
      end
    end
  end
end

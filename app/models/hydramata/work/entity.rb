require 'hydramata/work/conversions'
module Hydramata
  module Work
    # Responsible for being the in ruby representation of a set of Properties.
    #
    # Unlike the [ActiveRecord pattern](http://www.martinfowler.com/eaaCatalog/activeRecord.html),
    # there is no direct connection to a data storage. This is instead analogous
    # to the Entity of the [DataMapper pattern](http://www.martinfowler.com/eaaCatalog/dataMapper.html)
    # as implemented in [Lotus::Models](https://github.com/lotus/model#entities).
    #
    # Unlike a Lotus::Model, the Work is an arbitrary collection of Property
    # objects, as defined in the PropertySet.
    class Entity
      include Conversions

      def initialize(collaborators = {}, &block)
        self.work_type = collaborators[:work_type] if collaborators.key?(:work_type)
        self.identity = collaborators[:identity] if collaborators.key?(:identity)
        @properties = collaborators.fetch(:properties_container) { default_properties_container }
        @presenter_builder = collaborators.fetch(:presenter_builder) { default_presenter_builder }
        block.call(self) if block_given?
      end

      def work_type=(value)
        @work_type = WorkType(value)
      end

      def work_type
        @work_type ||= WorkType()
      end

      def identity=(value)
        @identity = value
      end

      def has_property?(predicate)
        properties.key?(predicate)
      end

      attr_reader :properties, :identity

      def to_translation_key_fragment
        work_type.to_translation_key_fragment
      end

      def name_for_application_usage
        work_type.name_for_application_usage
      end

      attr_reader :presenter_builder
      private :presenter_builder

      def to_presenter
        presenter_builder.call(self)
      end

      private


      def default_properties_container
        require 'hydramata/work/property_set'
        PropertySet.new(entity: self)
      end

      def default_presenter_builder
        require 'hydramata/work/entity_presenter'
        ->(entity) { EntityPresenter.new(entity: entity) }
      end
    end
  end
end

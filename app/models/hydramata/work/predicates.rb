require 'hydramata/work/predicate'
require 'hydramata/work/predicates/storage'

module Hydramata
  module Work
    module Predicates
      module_function
      def find(identity, attributes = {})
        predicate_attributes = attributes.merge(Predicates::Storage.existing_attributes_for(identity))
        Predicate.new(predicate_attributes)
      end
    end
  end
end

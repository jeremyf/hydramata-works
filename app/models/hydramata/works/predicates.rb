require 'hydramata/works/predicate'
require 'hydramata/works/predicates/storage'

module Hydramata
  module Works
    # A Container for interactions with Predicates
    module Predicates
      module_function

      # Responsible for fiding an existing Predicate and using those values
      def find(identity, attributes = {})
        predicate_attributes = attributes.merge(Predicates::Storage.existing_attributes_for(identity))
        Predicate.new(predicate_attributes)
      end
    end
  end
end

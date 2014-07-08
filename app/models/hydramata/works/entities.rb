require 'hydramata/works/entity'
module Hydramata
  module Works
    module Entities
      module_function
      def find(identifier)
        Entity.new(identifier: identifier)
      end
    end
  end
end
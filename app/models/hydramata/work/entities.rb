require 'hydramata/work/entity'
module Hydramata
  module Work
    module Entities
      module_function
      def find(identifier)
        Entity.new(identifier: identifier)
      end
    end
  end
end
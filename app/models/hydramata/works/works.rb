require 'hydramata/works/work'
module Hydramata
  module Works
    module Entities
      module_function
      def find(identifier)
        Work.new(identifier: identifier)
      end
    end
  end
end
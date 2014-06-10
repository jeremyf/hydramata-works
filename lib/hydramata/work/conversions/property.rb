require 'hydramata/work/conversions/exceptions'

module Hydramata
  module Work
    module Conversions
      private
      def Property(input)
        require 'hydramata/work/property'

        if input.instance_of?(Property)
          input
        else
          Property.new(input)
        end
      end
    end
  end
end

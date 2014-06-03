require 'hydramata/work/property'
module Hydramata
  module Work
    module Conversions
      private
      def Property(input)
        if input.instance_of?(Property)
          input
        else
          Property.new(input)
        end
      end
    end
  end
end

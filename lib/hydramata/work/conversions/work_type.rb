require 'hydramata/work/conversions/exceptions'
require 'hydramata/work/work_type'
require 'hydramata/work/work_types'

module Hydramata
  module Work
    module Conversions
      private
      def WorkType(input)
        case input
        when WorkType then input
        when WorkTypes::Storage then WorkType.new(input.attributes)
        when String, Symbol then WorkTypes.find(input)
        when Hash then WorkTypes.find(input.fetch(:identity), input)
        else
          raise ConversionError.new(:WorkType, input)
        end
      end
    end
  end
end

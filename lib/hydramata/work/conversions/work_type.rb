require 'hydramata/work/conversions/exceptions'
require 'hydramata/work/work_type'
require 'hydramata/work/work_types'

module Hydramata
  module Work
    module Conversions
      private
      def WorkType(input = nil)
        return input.to_work_type if input.respond_to?(:to_work_type)
        case input
        when WorkType then input
        when String, Symbol then WorkTypes.find(input)
        when Hash then WorkTypes.find(input.fetch(:identity), input)
        when NilClass then WorkType.new(identity: 'unknown')
        else
          if input.respond_to?(:empty?) && input.empty?
            WorkType.new(identity: 'unknown')
          else
            raise ConversionError.new(:WorkType, input)
          end
        end
      end
    end
  end
end

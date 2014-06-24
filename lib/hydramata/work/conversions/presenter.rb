require 'hydramata/work/conversions/exceptions'

module Hydramata
  module Work
    module Conversions
      private
      def Presenter(input)
        return input.to_presenter if input.respond_to?(:to_presenter)
        input
      end
    end
  end
end

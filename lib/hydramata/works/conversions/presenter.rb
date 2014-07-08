require 'hydramata/works/conversions/exceptions'

module Hydramata
  module Works
    module Conversions
      private
      def Presenter(input)
        return input.to_presenter if input.respond_to?(:to_presenter)
        input
      end
    end
  end
end

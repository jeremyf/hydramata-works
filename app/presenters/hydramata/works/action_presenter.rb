module Hydramata
  module Works
    class ActionPresenter
      attr_reader :name
      def initialize(name)
        @name = name
      end
      def render(options = {})
        template = options.fetch(:template)
        template.submit_tag(name)
      end
    end
  end
end

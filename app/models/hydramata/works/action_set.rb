module Hydramata
  module Works
    # Responsible for collecting and managing all of the actions within a given
    # context.
    class ActionSet
      include Enumerable

      def initialize(collaborators = {})
        @context = collaborators.fetch(:context)
        @action_builder = collaborators.fetch(:action_builder) { default_action_builder }
        @actions = {}
      end
      attr_reader :context, :action_builder
      private :action_builder

      def <<(options)
        name = options.fetch(:name)
        @actions[name] = action_builder.call(options.merge(context: context))
      end

      def each
        @actions.each { |_key, action| yield action }
      end

      def default_action_builder
        require 'hydramata/works/action_presenter'
        ActionPresenter.method(:new)
      end
    end
  end
end

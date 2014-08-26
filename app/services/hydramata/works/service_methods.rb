module Hydramata
  module Works
    # Responsible for being a collection of service methods that are useful
    # for negotiating between a context (i.e. a Controller request ) and the
    # domain model.
    #
    # This module defines the public API for interacting with Hydramata::Works.
    module ServiceMethods
      # @param :context [#current_user]
      # @param :work_type [String]
      # @param :attributes [Hash]
      # @yield [work]
      # @yieldparam work [WorkForm]
      # @return [WorkForm]
      def new_work_for(context, work_type, attributes = {}, &block)
        work = Work.new(work_type: work_type)
        ApplyUserInputToWork.call(work: work, attributes: attributes) if attributes.present?
        presenter = WorkPresenter.new(work: work, presentation_context: :new)
        presenter.actions << { name: :create }
        WorkForm.new(presenter, &block)
      end

      # @param :context [#current_user]
      # @return [Array(WorkType)]
      def available_work_types(context)
        WorkTypes::Storage.ordered.all.collect do |work_type|
          work_type.to_work_type(shallow: true).to_presenter
        end
      end
    end
  end
end

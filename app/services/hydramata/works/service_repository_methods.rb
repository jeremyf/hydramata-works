module Hydramata
  module Works
    # Responsible for being a collection of service methods that are useful
    # for negotiating between a context (i.e. a Controller request ) and the 
    # domain model.
    module ServiceRepositoryMethods
      def new_work_for(context, work_type, attributes)
        work = Hydramata::Works::Work.new(work_type: work_type)
        presenter = Hydramata::Works::WorkPresenter.new(work: work, presentation_context: :new)
        Hydramata::Works::WorkForm.new(presenter)
      end
    end
  end
end

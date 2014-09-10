module Hydramata
  module Works
    module ValuePresenterFinder
      module_function
      def call(predicate, options)
        if predicate.respond_to?(:value_presenter_class_name) && predicate.value_presenter_class_name
          "Hydramata::Works::#{predicate.value_presenter_class_name}".constantize.new(options)
        else
          ValuePresenter.new(options)
        end
      end
    end
  end
end

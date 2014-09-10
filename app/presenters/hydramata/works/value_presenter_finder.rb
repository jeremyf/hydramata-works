module Hydramata
  module Works
    module ValuePresenterFinder
      module_function
      def call(predicate, options)
        klass =
        if predicate.respond_to?(:value_presenter_class_name) && predicate.value_presenter_class_name
          begin
            predicate.value_presenter_class_name.constantize
          rescue NameError
            Hydramata::Works.const_get(predicate.value_presenter_class_name)
          rescue NameError
            ValuePresenter
          end
        else
          ValuePresenter
        end
        klass.new(options)
      end
    end
  end
end

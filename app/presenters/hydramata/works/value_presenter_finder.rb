module Hydramata
  module Works
    # Responsible for finding an appropriate constant that can be used
    # to build a ValuePresenter like object.
    module ValuePresenterFinder
      module_function
      def call(predicate)
        klass =
        if predicate.respond_to?(:value_presenter_class_name) && predicate.value_presenter_class_name
          class_name = predicate.value_presenter_class_name
          begin
            class_name.constantize
          rescue NameError, NoMethodError
            begin
              Hydramata::Works.const_get(class_name.to_s)
            rescue NameError
              require 'hydramata/works/value_presenter'
              ValuePresenter
            end
          end
        else
          require 'hydramata/works/value_presenter'
          ValuePresenter
        end
        klass
      end
    end
  end
end

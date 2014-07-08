require 'hydramata/works/engine' if defined?(Rails)
module Hydramata
  # Responsible for providing a well defined data-structure to ease the
  # interaction between differing layers of an application.
  #
  # * Persistence Layer
  # * In Memory
  # * Rendering/Output Buffer
  module Works
    module_function
    def table_name_prefix
      'hydramata_works_'
    end

    # Because I am not using isolate_namespace for Hydramata::Works::Engine
    # I need this for the application router to find the appropriate routes.
    # @api private
    def use_relative_model_naming?
      true
    end

  end
end

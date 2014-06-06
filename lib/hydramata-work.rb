require 'hydramata/work/engine' if defined?(Rails)
module Hydramata
  # Responsible for providing a well defined data-structure to ease the
  # interaction between differing layers of an application.
  #
  # * Persistence Layer
  # * In Memory
  # * Rendering/Output Buffer
  module Work
    def self.table_name_prefix
      'hydramata_work_'
    end
  end
end

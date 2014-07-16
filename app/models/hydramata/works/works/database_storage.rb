require 'active_record/base'

module Hydramata
  module Works
    module Works
      class DatabaseStorage < ActiveRecord::Base
        self.table_name = :hydramata_works_works
        serialize :properties, Hash
      end
    end
  end
end

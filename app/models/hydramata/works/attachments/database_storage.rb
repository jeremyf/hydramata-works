module Hydramata
  module Works
    module Attachments
      class DatabaseStorage < ActiveRecord::Base
        self.table_name = :hydramata_works_works
        self.primary_key = :pid
      end
    end
  end
end

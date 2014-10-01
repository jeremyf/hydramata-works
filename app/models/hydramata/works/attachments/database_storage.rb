require 'active_record'
require 'dragonfly/model'

module Hydramata
  module Works
    module Attachments
      class DatabaseStorage < ActiveRecord::Base
        extend Dragonfly::Model
        self.table_name = :hydramata_works_attachments
        self.primary_key = :pid
        dragonfly_accessor :file

        belongs_to(
          :work,
          class_name: 'Hydramata::Works::PersistedWorks::DatabaseStorage',
          foreign_key: 'work_id'
        )

        alias_attribute :original_filename, :file_name
      end
    end
  end
end

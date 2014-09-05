require 'active_record/base'
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
          class_name: '::Hydramata::Works::Works::DatabaseStorage',
          foreign_key: 'work_id'
        )

      end
    end
  end
end

module Hydramata
  module Work
    # A data-structure object that helps in transitioning a predicate from
    # one form to another (i.e. persistence to memory, memory to input)
    #
    # @TODO - Create an ActiveRecord::Base model of this.
    class Predicate < ActiveRecord::Base
      self.table_name = :hydramata_work_predicates

      def self.find_by_identity(identity)
        where(identity: identity).first
      end
    end
  end
end

# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'active_record_spec_helper'
require 'hydramata/work/predicate_presentation_sequences/storage'

module Hydramata
  module Work
    module PredicatePresentationSequences

      describe Storage do
        subject { described_class.new }
      end
    end
  end
end

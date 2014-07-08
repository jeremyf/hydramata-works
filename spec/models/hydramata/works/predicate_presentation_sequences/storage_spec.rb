# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'spec_active_record_helper'
require 'hydramata/works/predicate_presentation_sequences/storage'

module Hydramata
  module Works
    module PredicatePresentationSequences

      describe Storage do
        subject { described_class.new }
      end
    end
  end
end

# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'spec_active_record_helper'
require 'hydramata/works/predicate_presentation_sequences/storage'

module Hydramata
  module Works
    module PredicatePresentationSequences

      describe Storage do
        subject { described_class.new }

        it 'belongs to a work type' do
          expect(subject.predicate).to be_nil
        end

        it 'has many predicates' do
          expect(subject.predicate_set).to be_nil
        end

        it 'has a meaningful #to_s method' do
          # Alright not entirely meaningful
          expect(subject.to_s).to match(/>.*-/)
        end
      end
    end
  end
end

require 'spec_fast_helper'
require 'hydramata/works/presentation_structure'

module Hydramata
  module Works
    describe PresentationStructure do
      subject { described_class.new }
      let(:fieldset) { [:required, [:title]] }

      context '.build' do
        let(:object) { double('Object with predicate sets', predicate_sets: ['predicate_1', 'predicate_2']) }
        it 'transforms an entity\'s predicate_sets to fieldsets' do
          structure = described_class.build_from(object)
          expect(structure.fieldsets).to eq(object.predicate_sets)
        end
      end

      context '#fieldsets' do
        it 'can be appended' do
          expect { subject.fieldsets << fieldset }.
            to change { subject.fieldsets.count }.
            by(1)
        end
      end
    end
  end
end

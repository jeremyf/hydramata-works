require 'fast_helper'
require 'hydramata/work/entity_presenter'
require 'hydramata/work/linters'

module Hydramata
  module Work
    describe EntityPresenter do
      it_behaves_like 'a presented entity'

      let(:presentation_structure) { double('PresentationStructure') }
      let(:entity) { double('Entity', work_type: true) }
      let(:presented_fieldset_builder) { double('Builder', call: true) }
      subject do
        described_class.new(
          entity: entity,
          presentation_structure: presentation_structure,
          presented_fieldset_builder: presented_fieldset_builder
        )
      end

      it 'should have #fieldsets that are extracted from the #entity and #presentation_structure' do
        subject.fieldsets
        expect(presented_fieldset_builder).to have_received(:call).with(entity: subject, presentation_structure: presentation_structure)
      end

      it 'delegates :work_type to :entity' do
        subject.work_type
        expect(entity).to have_received(:work_type)
      end

    end
  end
end
